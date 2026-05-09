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
    source_file: ($) => choice($.query_package, $.query, $.destroy_statement),

    query_package: ($) =>
      seq(
        $.query,
        repeat1(seq(';', $.query)),
        optional(';'),
      ),

    query: ($) =>
      seq(
        $.select_section,
        repeat($.union_clause),
        optional($.order_by_clause),
        optional($.auto_order_clause),
        repeat($.totals_clause),
      ),

    select_section: ($) =>
      seq(
        $.SELECT_KEYWORD,
        optional($.ALLOWED_KEYWORD),
        optional($.DISTINCT_KEYWORD),
        optional($.top_clause),
        $.field_list,
        optional(choice($.into_clause, $.add_clause)),
        optional($.from_clause),
        optional($.where_clause),
        optional($.group_by_clause),
        optional($.having_clause),
        optional($.index_by_clause),
        optional($.for_update_clause),
      ),

    union_clause: ($) =>
      seq(
        $.UNION_KEYWORD,
        optional($.ALL_KEYWORD),
        $.select_section,
      ),

    order_by_clause: ($) =>
      seq($.ORDER_KEYWORD, $.BY_KEYWORD, $.ordering_list),

    ordering_list: ($) => sepBy1(',', $.ordering_item),

    ordering_item: ($) =>
      seq(
        field('value', $.query_expression),
        optional(field('direction', $.ordering_direction)),
      ),

    ordering_direction: ($) =>
      choice(
        $.ASC_KEYWORD,
        $.DESC_KEYWORD,
        $.HIERARCHY_KEYWORD,
        seq($.HIERARCHY_KEYWORD, $.DESC_KEYWORD),
      ),

    auto_order_clause: ($) => $.AUTO_ORDER_KEYWORD,

    totals_clause: ($) =>
      seq(
        $.TOTALS_KEYWORD,
        optional($.totals_field_list),
        choice(
          $.GENERAL_KEYWORD,
          seq(
            $.BY_KEYWORD,
            choice(
              $.GENERAL_KEYWORD,
              seq(optional($.GENERAL_KEYWORD), $.totals_group_list),
            ),
          ),
        ),
      ),

    totals_field_list: ($) => sepBy1(',', $.totals_field),

    totals_field: ($) =>
      seq(
        field('value', $.query_expression),
        optional($.field_alias),
      ),

    totals_group_list: ($) => sepBy1(',', $.totals_group),

    totals_group: ($) =>
      seq(
        field('value', $.query_expression),
        optional(choice(
          seq(optional($.ONLY_KEYWORD), $.HIERARCHY_KEYWORD),
          $.totals_periods_clause,
        )),
        optional($.field_alias),
      ),

    totals_periods_clause: ($) =>
      seq(
        $.PERIODS_KEYWORD,
        '(',
        field('period', $.totals_period_unit),
        optional(seq(
          ',',
          field('start', $.totals_period_bound),
          optional(seq(
            ',',
            field('end', $.totals_period_bound),
          )),
        )),
        ')',
      ),

    totals_period_unit: ($) =>
      choice(
        $.SECOND_KEYWORD,
        $.MINUTE_KEYWORD,
        $.HOUR_KEYWORD,
        $.DAY_KEYWORD,
        $.WEEK_KEYWORD,
        $.MONTH_KEYWORD,
        $.QUARTER_KEYWORD,
        $.YEAR_KEYWORD,
        $.TEN_DAYS_KEYWORD,
        $.HALF_YEAR_KEYWORD,
      ),

    totals_period_bound: ($) =>
      choice(
        $.date_time_literal,
        $.date,
        $.parameter,
      ),

    top_clause: ($) => seq($.TOP_KEYWORD, field('count', $.number)),

    field_list: ($) => choice($.wildcard, sepBy1(',', $.field)),

    field: ($) =>
      prec.right(seq(
        field('value', choice(
          $.nested_table_field_expression,
          $.empty_table_expression,
          $.query_expression,
        )),
        optional($.field_alias),
      )),

    field_alias: ($) => seq(optional($.AS_KEYWORD), $._alias_identifier),

    wildcard: () => '*',

    nested_table_field_expression: ($) =>
      prec(
        PREC.CALL,
        seq(
          field('table', $._qualified_name),
          field('group', $.nested_field_group),
        ),
      ),

    nested_field_group: ($) =>
      choice(
        alias('.*', $.wildcard),
        seq('.(', field('fields', $.nested_field_list), ')'),
      ),

    nested_field_list: ($) => sepBy1(',', $.nested_field),

    nested_field: ($) =>
      seq(
        field('value', $.query_expression),
        optional($.field_alias),
      ),

    empty_table_expression: ($) =>
      seq(
        $.EMPTY_TABLE_KEYWORD,
        '.',
        '(',
        field('fields', $.empty_table_field_list),
        ')',
      ),

    empty_table_field_list: ($) => sepBy1(',', $.identifier),

    into_clause: ($) => seq($.INTO_KEYWORD, field('name', $.identifier)),

    add_clause: ($) => seq($.ADD_KEYWORD, field('name', $.identifier)),

    destroy_statement: ($) =>
      seq($.DESTROY_KEYWORD, field('name', $.identifier)),

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
        $.parameter,
        $._qualified_name,
      ),

    virtual_table_source: ($) =>
      seq(
        field('name', $._qualified_name),
        $.virtual_table_parameters,
      ),

    virtual_table_parameters: ($) =>
      seq(
        '(',
        optional(choice(
          $.expression_list,
          $._virtual_table_parameter_list,
        )),
        ')',
      ),

    _virtual_table_parameter_list: ($) =>
      prec.right(-1, choice(
        $.query_expression,
        seq($.query_expression, ',', $._virtual_table_parameter_list),
        seq($.query_expression, alias(',', $.omitted_argument)),
        seq(alias(',', $.omitted_argument), optional($._virtual_table_parameter_list)),
      )),

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

    omitted_argument: () => ',',

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
        $.date_time_literal,
        $.type_literal,
        $.predefined_value_literal,
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
          field('pattern', $.query_expression),
          optional(seq($.SPECIALCHAR_KEYWORD, field('escape', $.query_expression))),
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

    date_time_literal: ($) =>
      prec(
        PREC.CALL,
        seq(
          $.DATETIME_KEYWORD,
          '(',
          field('year', $.number),
          ',',
          field('month', $.number),
          ',',
          field('day', $.number),
          optional(seq(
            ',',
            field('hour', $.number),
            ',',
            field('minute', $.number),
            ',',
            field('second', $.number),
          )),
          ')',
        ),
      ),

    type_literal: ($) =>
      prec(
        PREC.CALL,
        seq(
          $.TYPE_KEYWORD,
          '(',
          field('type', $.type_literal_name),
          ')',
        ),
      ),

    type_literal_name: ($) =>
      choice(
        $.BOOLEAN_TYPE_KEYWORD,
        $.DATE_TYPE_KEYWORD,
        $.NUMBER_TYPE_KEYWORD,
        $.STRING_TYPE_KEYWORD,
        $._qualified_name,
      ),

    predefined_value_literal: ($) =>
      prec(
        PREC.CALL,
        seq(
          $.VALUE_KEYWORD,
          '(',
          field('value', $.dotted_identifier),
          ')',
        ),
      ),

    function_call: ($) =>
      prec(
        PREC.CALL,
        seq(
          field('name', $._function_name),
          $.function_arguments,
        ),
      ),

    _function_name: ($) =>
      choice(
        $.identifier,
        alias($.TYPE_VALUE_FUNCTION_NAME, $.identifier),
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
          optional(field('value', $.query_expression)),
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

    dotted_identifier: ($) =>
      prec.right(seq($.identifier, repeat1(seq('.', $.identifier)))),

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
        alias($.ADD_KEYWORD, $.identifier),
      ),

    SELECT_KEYWORD: () => keyword('выбрать', 'select'),
    EMPTY_TABLE_KEYWORD: () => keyword('пустаятаблица', 'emptytable'),
    ALLOWED_KEYWORD: () => keyword('разрешенные', 'allowed'),
    DISTINCT_KEYWORD: () => keyword('различные', 'distinct'),
    TOP_KEYWORD: () => keyword('первые', 'top'),
    INTO_KEYWORD: () => keyword('поместить', 'into'),
    ADD_KEYWORD: () => keyword('добавить', 'add'),
    DESTROY_KEYWORD: () => keyword('уничтожить', 'drop'),
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
    HIERARCHY_KEYWORD: () => keyword('иерархии', 'иерархия', 'hierarchy'),
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
    DATETIME_KEYWORD: () => keyword('датавремя', 'datetime'),
    TYPE_KEYWORD: () => keyword('тип', 'type'),
    TYPE_VALUE_FUNCTION_NAME: () => token(prec(2, /типзначения/i)),
    VALUE_KEYWORD: () => keyword('значение', 'value'),
    BOOLEAN_TYPE_KEYWORD: () => keyword('булево', 'boolean'),
    NUMBER_TYPE_KEYWORD: () => keyword('число', 'number'),
    STRING_TYPE_KEYWORD: () => keyword('строка', 'string'),
    DATE_TYPE_KEYWORD: () => keyword('дата', 'date'),
    UNION_KEYWORD: () => keyword('объединить', 'union'),
    ALL_KEYWORD: () => keyword('все', 'all'),
    ORDER_KEYWORD: () => keyword('упорядочить', 'order'),
    AUTO_ORDER_KEYWORD: () => keyword('автоупорядочивание', 'autoorder'),
    TOTALS_KEYWORD: () => keyword('итоги', 'totals'),
    PERIODS_KEYWORD: () => keyword('периодами', 'periods'),
    SECOND_KEYWORD: () => keyword('секунда', 'second'),
    MINUTE_KEYWORD: () => keyword('минута', 'minute'),
    HOUR_KEYWORD: () => keyword('час', 'hour'),
    DAY_KEYWORD: () => keyword('день', 'day'),
    WEEK_KEYWORD: () => keyword('неделя', 'week'),
    MONTH_KEYWORD: () => keyword('месяц', 'month'),
    QUARTER_KEYWORD: () => keyword('квартал', 'quarter'),
    YEAR_KEYWORD: () => keyword('год', 'year'),
    TEN_DAYS_KEYWORD: () => keyword('декада', 'tendays'),
    HALF_YEAR_KEYWORD: () => keyword('полугодие', 'halfyear'),
    ASC_KEYWORD: () => keyword('возр', 'asc'),
    DESC_KEYWORD: () => keyword('убыв', 'desc'),
    GENERAL_KEYWORD: () => keyword('общие', 'overall'),
    ONLY_KEYWORD: () => keyword('только', 'only'),
  },
});

function sepBy1(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}
