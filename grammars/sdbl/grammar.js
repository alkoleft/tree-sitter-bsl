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
  UNARY: 4,
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

    field_alias: ($) => seq(optional($.AS_KEYWORD), $.identifier),

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
        $.parenthesized_expression,
      ),

    parenthesized_expression: ($) => seq('(', $.query_expression, ')'),

    unary_expression: ($) =>
      prec.right(
        PREC.UNARY,
        seq(
          field('operator', $.not_operator),
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
      ),

    _qualified_name: ($) => choice($.dotted_identifier, $.identifier),

    dotted_identifier: ($) => seq($.identifier, repeat1(seq('.', $.identifier))),

    parameter: ($) => seq('&', $.identifier),

    boolean: ($) => choice($.TRUE_KEYWORD, $.FALSE_KEYWORD),

    null: ($) => $.NULL_KEYWORD,

    undefined: ($) => $.UNDEFINED_KEYWORD,

    not_operator: ($) => $.NOT_KEYWORD,

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
    INNER_KEYWORD: () => keyword('внутреннее', 'inner'),
    LEFT_KEYWORD: () => keyword('левое', 'left'),
    RIGHT_KEYWORD: () => keyword('правое', 'right'),
    FULL_KEYWORD: () => keyword('полное', 'full'),
    OUTER_KEYWORD: () => keyword('внешнее', 'outer'),
    JOIN_KEYWORD: () => keyword('соединение', 'join'),
    ON_KEYWORD: () => keyword('по', 'on'),
  },
});

function sepBy1(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}
