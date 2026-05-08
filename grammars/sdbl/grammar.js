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
        optional($.from_clause),
        optional($.where_clause),
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

    from_clause: ($) => seq($.FROM_KEYWORD, $.source_list),

    source_list: ($) => sepBy1(',', $.table_source),

    table_source: ($) =>
      seq(
        field('name', $._qualified_name),
        optional($.source_alias),
      ),

    source_alias: ($) => seq(optional($.AS_KEYWORD), $.identifier),

    where_clause: ($) => seq($.WHERE_KEYWORD, $.query_expression),

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
    FROM_KEYWORD: () => keyword('из', 'from'),
    WHERE_KEYWORD: () => keyword('где', 'where'),
    AS_KEYWORD: () => keyword('как', 'as'),
    TRUE_KEYWORD: () => keyword('истина', 'true'),
    FALSE_KEYWORD: () => keyword('ложь', 'false'),
    NULL_KEYWORD: () => keyword('null'),
    UNDEFINED_KEYWORD: () => keyword('неопределено', 'undefined'),
    AND_KEYWORD: () => keyword('и', 'and'),
    OR_KEYWORD: () => keyword('или', 'or'),
    NOT_KEYWORD: () => keyword('не', 'not'),
  },
});

function sepBy1(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}
