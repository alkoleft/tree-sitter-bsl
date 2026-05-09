(bsl_string_delimiter) @string
(bsl_string_continuation) @punctuation.special

(line_comment) @comment

[
  (ADD_KEYWORD)
  (ALLOWED_KEYWORD)
  (ALL_KEYWORD)
  (AND_KEYWORD)
  (AS_KEYWORD)
  (ASC_KEYWORD)
  (AUTO_ORDER_KEYWORD)
  (BETWEEN_KEYWORD)
  (BY_KEYWORD)
  (CASE_KEYWORD)
  (CAST_KEYWORD)
  (DATETIME_KEYWORD)
  (DESC_KEYWORD)
  (DESTROY_KEYWORD)
  (DISTINCT_KEYWORD)
  (ELSE_KEYWORD)
  (EMPTY_TABLE_KEYWORD)
  (END_KEYWORD)
  (FOR_KEYWORD)
  (FROM_KEYWORD)
  (FULL_KEYWORD)
  (GENERAL_KEYWORD)
  (GROUP_KEYWORD)
  (HAVING_KEYWORD)
  (HIERARCHY_KEYWORD)
  (INDEX_KEYWORD)
  (INNER_KEYWORD)
  (INTO_KEYWORD)
  (IN_KEYWORD)
  (IS_KEYWORD)
  (JOIN_KEYWORD)
  (LEFT_KEYWORD)
  (LIKE_KEYWORD)
  (NOT_KEYWORD)
  (OF_KEYWORD)
  (ON_KEYWORD)
  (ONLY_KEYWORD)
  (OR_KEYWORD)
  (ORDER_KEYWORD)
  (OUTER_KEYWORD)
  (PERIODS_KEYWORD)
  (REFERENCE_KEYWORD)
  (RIGHT_KEYWORD)
  (SELECT_KEYWORD)
  (SPECIALCHAR_KEYWORD)
  (THEN_KEYWORD)
  (TOP_KEYWORD)
  (TOTALS_KEYWORD)
  (UNION_KEYWORD)
  (UPDATE_KEYWORD)
  (WHEN_KEYWORD)
  (WHERE_KEYWORD)
] @keyword

[
  (BOOLEAN_TYPE_KEYWORD)
  (DATE_TYPE_KEYWORD)
  (NUMBER_TYPE_KEYWORD)
  (STRING_TYPE_KEYWORD)
  (TYPE_KEYWORD)
  (VALUE_KEYWORD)
] @type

[
  (FALSE_KEYWORD)
  (NULL_KEYWORD)
  (TRUE_KEYWORD)
  (UNDEFINED_KEYWORD)
] @constant.builtin

[
  (DAY_KEYWORD)
  (HALF_YEAR_KEYWORD)
  (HOUR_KEYWORD)
  (MINUTE_KEYWORD)
  (MONTH_KEYWORD)
  (QUARTER_KEYWORD)
  (SECOND_KEYWORD)
  (TEN_DAYS_KEYWORD)
  (WEEK_KEYWORD)
  (YEAR_KEYWORD)
] @constant

((identifier) @variable
  (#set! priority 95))
((dotted_identifier) @variable
  (#set! priority 95))

((function_call
  name: (identifier) @function.builtin)
  (#set! priority 110))

((aggregate_function
  name: (aggregate_function_name) @function.builtin)
  (#set! priority 110))

((parameter) @constant.builtin
  (#set! priority 120))
((parameter
  "&" @constant.builtin
  (identifier) @constant.builtin)
  (#set! priority 120))

[
  (date)
  (date_time_literal)
] @constant

(number) @number
(string) @string

[
  (comparison_operator)
  (arithmetic_operator)
  (not_operator)
  (sign_operator)
] @operator

[
  "("
  ")"
] @punctuation.bracket

[
  ";"
  "."
  ","
] @punctuation.delimiter
