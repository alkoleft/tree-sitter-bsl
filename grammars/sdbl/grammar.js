/// <reference types='tree-sitter-cli/dsl' />

const keyword = (...words) => {
  const rule = words.length === 1
    ? caseInsensitive(words[0])
    : choice(...words.map(caseInsensitive));
  return token(prec(1, rule));
};
const caseInsensitive = (word) => new RegExp(word, 'i');

const PREC = {
  OR: 1,
  AND: 2,
  COMPARE: 3,
  ADDITIVE: 4,
  MULTIPLICATIVE: 5,
  UNARY: 6,
  CALL: 7,
};

module.exports = grammar({
  name: 'sdbl',

  extras: ($) => [/\s/, $.line_comment],

  word: ($) => $.identifier,

  rules: {
    query: ($) => $.select_section,

    select_section: ($) =>
      seq(
        $.SELECT_KEYWORD,
        optional($.ALLOWED_KEYWORD),
        optional($.DISTINCT_KEYWORD),
        optional($.top_clause),
        $.field_list,
        optional($.into_clause),
        optional($.from_clause),
        optional($.index_by_clause),
        optional($.where_clause),
        optional($.group_by_clause),
        optional($.having_clause),
        optional($.for_update_clause),
      ),

    top_clause: ($) => seq($.TOP_KEYWORD, field('count', $.number)),

    field_list: ($) => choice($.wildcard, sepBy1(',', $.field)),

    field: ($) =>
      seq(
        field('value', $.query_expression),
        optional($.field_alias),
      ),

    field_alias: ($) => seq(optional($.AS_KEYWORD), $._alias_identifier),

    wildcard: () => '*',

    into_clause: ($) => seq($.INTO_KEYWORD, field('name', $.identifier)),

    from_clause: ($) => seq($.FROM_KEYWORD, $.source_list),

    source_list: ($) => sepBy1(',', $.table_source),

    table_source: ($) =>
      seq(
        field('name', $._source_description),
        optional($.source_alias),
        repeat($.join_clause),
      ),

    _source_description: ($) =>
      choice(
        $.virtual_table_source,
        $.nested_query_source,
        $._qualified_name,
      ),

    virtual_table_source: ($) =>
      seq(
        field('name', $._qualified_name),
        $.virtual_table_parameters,
      ),

    virtual_table_parameters: ($) =>
      seq('(', optional($.expression_list), ')'),

    nested_query_source: ($) => seq('(', $.query, ')'),

    source_alias: ($) => seq(optional($.AS_KEYWORD), $.identifier),

    join_clause: ($) =>
      seq(
        optional(field('kind', $.join_kind)),
        $.JOIN_KEYWORD,
        field('source', $._source_description),
        optional($.source_alias),
        $.ON_KEYWORD,
        field('condition', $.query_expression),
      ),

    join_kind: ($) =>
      choice(
        $.INNER_KEYWORD,
        seq($.LEFT_KEYWORD, optional($.OUTER_KEYWORD)),
        seq($.RIGHT_KEYWORD, optional($.OUTER_KEYWORD)),
        seq($.FULL_KEYWORD, optional($.OUTER_KEYWORD)),
      ),

    index_by_clause: ($) =>
      seq($.INDEX_KEYWORD, $.BY_KEYWORD, $.expression_list),

    where_clause: ($) => seq($.WHERE_KEYWORD, $.query_expression),

    group_by_clause: ($) =>
      seq($.GROUP_KEYWORD, $.BY_KEYWORD, $.expression_list),

    having_clause: ($) => seq($.HAVING_KEYWORD, $.query_expression),

    for_update_clause: ($) =>
      seq(
        $.FOR_KEYWORD,
        $.UPDATE_KEYWORD,
        optional(seq(optional($.OF_KEYWORD), $.table_list)),
      ),

    expression_list: ($) => sepBy1(',', $.query_expression),

    table_list: ($) => sepBy1(',', $._qualified_name),

    query_expression: ($) =>
      choice(
        $._qualified_name,
        $.parameter,
        $.number,
        $.date,
        $.string,
        $.boolean,
        $.null,
        $.undefined,
        $.unary_expression,
        $.binary_expression,
        $.membership_expression,
        $.between_expression,
        $.like_expression,
        $.null_check_expression,
        $.reference_check_expression,
        $.parenthesized_expression,
        $.function_call,
        $.aggregate_function,
        $.case_expression,
        $.cast_expression,
      ),

    parenthesized_expression: ($) => seq('(', $.query_expression, ')'),

    unary_expression: ($) =>
      prec.right(
        PREC.UNARY,
        seq(
          field('operator', choice($.not_operator, $.sign_operator)),
          field('argument', $.query_expression),
        ),
      ),

    binary_expression: ($) =>
      choice(
        prec.left(
          PREC.OR,
          seq(
            field('left', $.query_expression),
            field('operator', $.OR_KEYWORD),
            field('right', $.query_expression),
          ),
        ),
        prec.left(
          PREC.AND,
          seq(
            field('left', $.query_expression),
            field('operator', $.AND_KEYWORD),
            field('right', $.query_expression),
          ),
        ),
        prec.left(
          PREC.COMPARE,
          seq(
            field('left', $.query_expression),
            field('operator', $.comparison_operator),
            field('right', $.query_expression),
          ),
        ),
        prec.left(
          PREC.ADDITIVE,
          seq(
            field('left', $.query_expression),
            field('operator', alias(choice('+', '-'), $.arithmetic_operator)),
            field('right', $.query_expression),
          ),
        ),
        prec.left(
          PREC.MULTIPLICATIVE,
          seq(
            field('left', $.query_expression),
            field('operator', alias(choice('*', '/'), $.arithmetic_operator)),
            field('right', $.query_expression),
          ),
        ),
      ),

    membership_expression: ($) =>
      prec.left(
        PREC.COMPARE,
        seq(
          field('left', $.query_expression),
          optional(field('not', $.NOT_KEYWORD)),
          $.IN_KEYWORD,
          optional($.HIERARCHY_KEYWORD),
          field('right', choice($.value_list, $.subquery_expression)),
        ),
      ),

    value_list: ($) => seq('(', $.expression_list, ')'),

    subquery_expression: ($) => seq('(', $.query, ')'),

    between_expression: ($) =>
      prec.left(
        PREC.COMPARE,
        seq(
          field('left', $.query_expression),
          optional(field('not', $.NOT_KEYWORD)),
          $.BETWEEN_KEYWORD,
          field('lower', $.query_expression),
          $.AND_KEYWORD,
          field('upper', $.query_expression),
        ),
      ),

    like_expression: ($) =>
      prec.left(
        PREC.COMPARE,
        seq(
          field('left', $.query_expression),
          optional(field('not', $.NOT_KEYWORD)),
          $.LIKE_KEYWORD,
          field('pattern', $.string),
          optional(seq($.SPECIALCHAR_KEYWORD, field('escape', $.string))),
        ),
      ),

    null_check_expression: ($) =>
      prec.left(
        PREC.COMPARE,
        seq(
          field('left', $.query_expression),
          $.IS_KEYWORD,
          optional(field('not', $.NOT_KEYWORD)),
          $.NULL_KEYWORD,
        ),
      ),

    reference_check_expression: ($) =>
      prec.left(
        PREC.COMPARE,
        seq(
          field('left', $.query_expression),
          $.REFERENCE_KEYWORD,
          field('table', $.dotted_identifier),
        ),
      ),

    function_call: ($) =>
      prec(
        PREC.CALL,
        seq(
          field('name', $.identifier),
          $.function_arguments,
        ),
      ),

    function_arguments: ($) =>
      seq('(', optional($.expression_list), ')'),

    aggregate_function: ($) =>
      prec(
        PREC.CALL,
        seq(
          field('name', $.aggregate_function_name),
          choice(
            seq(optional($.DISTINCT_KEYWORD), field('argument', $.query_expression)),
            field('argument', $.wildcard),
          ),
          ')',
        ),
      ),

    aggregate_function_name: ($) =>
      token(prec(2, choice(
        /сумма\s*\(/i,
        /sum\s*\(/i,
        /среднее\s*\(/i,
        /avg\s*\(/i,
        /average\s*\(/i,
        /минимум\s*\(/i,
        /min\s*\(/i,
        /minimum\s*\(/i,
        /максимум\s*\(/i,
        /max\s*\(/i,
        /maximum\s*\(/i,
        /количество\s*\(/i,
        /count\s*\(/i,
      ))),

    case_expression: ($) =>
      prec.right(
        seq(
          $.CASE_KEYWORD,
          repeat1($.case_when_clause),
          optional($.case_else_clause),
          $.END_KEYWORD,
        ),
      ),

    case_when_clause: ($) =>
      seq(
        $.WHEN_KEYWORD,
        field('condition', $.query_expression),
        $.THEN_KEYWORD,
        field('result', $.query_expression),
      ),

    case_else_clause: ($) =>
      seq(
        $.ELSE_KEYWORD,
        field('result', $.query_expression),
      ),

    cast_expression: ($) =>
      prec(
        PREC.CALL,
        seq(
          $.CAST_KEYWORD,
          '(',
          field('value', $.query_expression),
          $.AS_KEYWORD,
          field('type', $.cast_type),
          ')',
        ),
      ),

    cast_type: ($) =>
      choice(
        $.BOOLEAN_TYPE_KEYWORD,
        $.DATE_TYPE_KEYWORD,
        seq(
          $.NUMBER_TYPE_KEYWORD,
          optional(seq(
            '(',
            field('length', $.number),
            optional(seq(',', field('precision', $.number))),
            ')',
          )),
        ),
        seq(
          $.STRING_TYPE_KEYWORD,
          optional(seq('(', field('length', $.number), ')')),
        ),
        $._qualified_name,
      ),

    _qualified_name: ($) => choice($.dotted_identifier, $.identifier),

    dotted_identifier: ($) => seq($.identifier, repeat1(seq('.', $.identifier))),

    parameter: ($) => seq('&', $.identifier),

    boolean: ($) => choice($.TRUE_KEYWORD, $.FALSE_KEYWORD),

    null: ($) => $.NULL_KEYWORD,

    undefined: ($) => $.UNDEFINED_KEYWORD,

    not_operator: ($) => $.NOT_KEYWORD,

    sign_operator: () => token(choice('+', '-')),

    comparison_operator: () => token(choice('<>', '<=', '>=', '=', '<', '>')),

    number: () => /\d+(\.\d+)?/,

    date: () => /'\d{8,14}'/,

    string: ($) =>
      seq(
        '"',
        alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
        '"',
      ),

    line_comment: () => token(seq('//', /.*/)),

    identifier: () => token(prec(-1, /[a-zA-Zа-яА-ЯёЁ_][a-zA-Zа-яА-ЯёЁ0-9_]*/)),

    _alias_identifier: ($) =>
      choice(
        $.identifier,
        alias($.REFERENCE_KEYWORD, $.identifier),
      ),

    SELECT_KEYWORD: () => keyword('выбрать', 'select'),
    ALLOWED_KEYWORD: () => keyword('разрешенные', 'allowed'),
    DISTINCT_KEYWORD: () => keyword('различные', 'distinct'),
    TOP_KEYWORD: () => keyword('первые', 'top'),
    INTO_KEYWORD: () => keyword('поместить', 'into'),
    FROM_KEYWORD: () => keyword('из', 'from'),
    INDEX_KEYWORD: () => keyword('индексировать', 'index'),
    BY_KEYWORD: () => keyword('по', 'by'),
    WHERE_KEYWORD: () => keyword('где', 'where'),
    GROUP_KEYWORD: () => keyword('сгруппировать', 'group'),
    HAVING_KEYWORD: () => keyword('имеющие', 'having'),
    FOR_KEYWORD: () => keyword('для', 'for'),
    UPDATE_KEYWORD: () => keyword('изменения', 'update'),
    OF_KEYWORD: () => keyword('of'),
    AS_KEYWORD: () => keyword('как', 'as'),
    TRUE_KEYWORD: () => keyword('истина', 'true'),
    FALSE_KEYWORD: () => keyword('ложь', 'false'),
    NULL_KEYWORD: () => keyword('null'),
    UNDEFINED_KEYWORD: () => keyword('неопределено', 'undefined'),
    AND_KEYWORD: () => keyword('и', 'and'),
    OR_KEYWORD: () => keyword('или', 'or'),
    NOT_KEYWORD: () => keyword('не', 'not'),
    IN_KEYWORD: () => keyword('в', 'in'),
    HIERARCHY_KEYWORD: () => keyword('иерархии', 'hierarchy'),
    BETWEEN_KEYWORD: () => keyword('между', 'between'),
    LIKE_KEYWORD: () => keyword('подобно', 'like'),
    SPECIALCHAR_KEYWORD: () => keyword('спецсимвол', 'escape'),
    IS_KEYWORD: () => keyword('есть', 'is'),
    REFERENCE_KEYWORD: () => keyword('ссылка', 'reference'),
    INNER_KEYWORD: () => keyword('внутреннее', 'inner'),
    LEFT_KEYWORD: () => keyword('левое', 'left'),
    RIGHT_KEYWORD: () => keyword('правое', 'right'),
    FULL_KEYWORD: () => keyword('полное', 'full'),
    OUTER_KEYWORD: () => keyword('внешнее', 'outer'),
    JOIN_KEYWORD: () => keyword('соединение', 'join'),
    ON_KEYWORD: () => keyword('по', 'on'),
    CASE_KEYWORD: () => keyword('выбор', 'case'),
    WHEN_KEYWORD: () => keyword('когда', 'when'),
    THEN_KEYWORD: () => keyword('тогда', 'then'),
    ELSE_KEYWORD: () => keyword('иначе', 'else'),
    END_KEYWORD: () => keyword('конец', 'end'),
    CAST_KEYWORD: () => keyword('выразить', 'cast'),
    BOOLEAN_TYPE_KEYWORD: () => keyword('булево', 'boolean'),
    NUMBER_TYPE_KEYWORD: () => keyword('число', 'number'),
    STRING_TYPE_KEYWORD: () => keyword('строка', 'string'),
    DATE_TYPE_KEYWORD: () => keyword('дата', 'date'),
  },
});

function sepBy1(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}
