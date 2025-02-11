/**
 * @file Tree sitter parser for bsl
 * @author Dmitrii Liubanevich <dlyubanevich@gmail.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

// https://its.1c.ru/db/v838doc#bookmark:dev:TI000000139
const TOKEN_TREE_NON_SPECIAL_PUNCTUATION = [
  "+",
  "-",
  "*",
  "/",
  "%",
  "<>",
  "=",
  ">",
  "<",
  ">=",
  "<=",
  ".",
  ",",
  ";",
  ":",
  "?",
  "~",
  "|",
  "&",
  "#",
];

const Keywords = {
  IF_KEYWORD: ($) => choice(/(Если)/i, /(if)/i),

  THEN_KEYWORD: ($) => choice(/(Тогда)/i, /(then)/i),

  ELSIF_KEYWORD: ($) => choice(/(ИначеЕсли)/i, /(elsif)/i),

  ELSE_KEYWORD: ($) => choice(/(Иначе)/i, /(else)/i),

  ENDIF_KEYWORD: ($) => choice(/(КонецЕсли)/i, /(endif)/i),

  _for_keyword: ($) => choice(/(Для)/i, /(for)/i),

  _each_keyword: ($) => choice(/(Каждого)/i, /(each)/i),

  _in_keyword: ($) => choice(/(Из)/i, /(in)/i),

  _to_keyword: ($) => choice(/(По)/i, /(to)/i),

  _while_keyword: ($) => choice(/(Пока)/i, /(while)/i),

  _do_keyword: ($) => choice(/(Цикл)/i, /(do)/i),

  _end_do_keyword: ($) => choice(/(КонецЦикла)/i, /(enddo)/i),

  _procedure_keyword: ($) => choice(/(Процедура)/i, /(procedure)/i),

  _function_keyword: ($) => choice(/(Функция)/i, /(function)/i),

  _end_procedure_keyword: ($) => choice(/(КонецПроцедуры)/i, /(endprocedure)/i),

  _end_function_keyword: ($) => choice(/(КонецФункции)/i, /(endfunction)/i),

  _var_keyword: ($) => choice(/Перем/iu, /var/i),

  _goto_keyword: ($) => choice(/(Перейти)/i, /(goto)/i),

  RETURN_KEYWORD: ($) => choice(/(Возврат)/i, /(return)/i),

  _continue_keyword: ($) => choice(/(Продолжить)/i, /(continue)/i),

  _break_keyword: ($) => choice(/(Прервать)/i, /(break)/i),

  _and_keyword: ($) => choice(/(И)/i, /(and)/i),

  _or_keyword: ($) => choice(/(Или)/i, /(or)/i),

  _not_keyword: ($) => choice(/(Не)/i, /(not)/i),

  _try_keyword: ($) => choice(/(Попытка)/i, /(try)/i),

  _except_keyword: ($) => choice(/(Исключение)/i, /(except)/i),

  _raise_keyword: ($) => choice(/(ВызватьИсключение)/i, /(raise)/i),

  _endtry_keyword: ($) => choice(/(КонецПопытки)/i, /(endtry)/i),

  _new_keyword: ($) => choice(/(Новый)/i, /(new)/i),

  _execute_keyword: ($) => choice(/(Выполнить)/i, /(execute)/i),

  val_keyword: ($) => choice(/(Знач)/i, /(val)/i),

  boolean: ($) => choice(/(Истина)/i, /(true)/i, /(Ложь)/i, /(false)/i),

  null: ($) => /(null)/i,

  undefined: ($) => choice(/(Неопределено)/i, /(undefine)/i),

  export_modifier: ($) => choice(/(Экспорт)/i, /(export)/i),
};

const Operations = {
  boolOperation: ($) => choice($._and_keyword, $._or_keyword),
  compareOperation: ($) => choice("<>", "=", ">", "<", ">=", "<="),
  operation: ($) =>
    choice("+", "-", "*", "/", "%", $.boolOperation, $.compareOperation),
};

module.exports = grammar({
  name: "bsl",
  extras: ($) => [/\s/, $.line_comment],

  supertypes: ($) => [],

  inline: ($) => [$._non_special_token],

  conflicts: ($) => [],

  word: ($) => $.identifier,

  rules: {
    source_file: ($) => repeat($._definition),

    _definition: ($) =>
      choice(
        $.var_definition,
        //$.region_definition,
        $._method_definition,
        $.statement
      ),

    _method_definition: ($) =>
      choice($.procedure_definition, $.function_definition),

    var_definition: ($) =>
      seq(
        $._var_keyword,
        sepBy(",", $.identifier),
        optional($.export_modifier),
        ";"
      ),

    procedure_definition: ($) =>
      seq(
        $._procedure_keyword,
        field("name", $.identifier),
        field("parameters", $.parameters),
        field("isExport", optional($.export_modifier)),
        optional($.body),
        $._end_procedure_keyword
      ),

    function_definition: ($) =>
      seq(
        $._function_keyword,
        field("name", $.identifier),
        field("parameters", $.parameters),
        field("isExport", optional($.export_modifier)),
        optional($.body),
        $._end_function_keyword
      ),

    parameters: ($) => seq("(", sepBy(",", optional($.parameter)), ")"),

    parameter: ($) =>
      seq(
        field("val", optional($.val_keyword)),
        $.identifier,
        optional($.def_value)
      ),

    def_value: ($) => seq("=", $.constValue),
    constValue: ($) =>
      choice(
        $.number,
        $.string,
        $.boolean,
        $.undefined,
        $.null
        //TODO Date
      ),
    body: ($) => seq($.statement),

    statement: ($) => choice($.assignment_statement, $.return_statement),

    return_statement: ($) =>
      choice(prec.left(seq($.RETURN_KEYWORD, optional($.expression)))),
    expression: ($) =>
      choice(
        $.constValue,
        $.identifier,
        $.unary_expression,
        $.binary_expression,
        $.ternary_expression
      ),
    assignment_statement: ($) =>
      seq(field("left", $.leftValue), "=", field("right", $.expression), ";"),
    unary_expression: ($) =>
      prec.left(
        seq(
          field("operator", choice("-", "+", "not", "не")),
          field("argument", $.expression)
        )
      ),

    binary_expression: ($) =>
      prec.left(
        seq(
          field("left", $.expression),
          field("operator", $.operation),
          field("right", $.expression)
        )
      ),

    ternary_expression: ($) =>
      prec.right(
        seq(
          "?(",
          field("condition", $.expression),
          ",",
          field("consequence", $.expression),
          ",",
          field("alternative", $.expression),
          ")"
        )
      ),
    leftValue: ($) => choice($.identifier),

    member: ($) =>
      choice(
        $.constValue,
        $.identifier
        // TODO: other kinds of expressions
      ),
    member_expression: ($) => prec.left(seq($.expression, $.identifier)),
    line_comment: ($) => seq("//", /.*/),

    // Section - Types

    _type: ($) => choice(),

    // Section - Keywords

    ...Keywords,
    ...Operations,
    identifier: ($) => /[\wа-я_][\wа-я_0-9]*/i,
    complexIdentifier: ($) => sepBy(".", $.identifier),

    number: ($) => /\d+|\d*\.\d+([eE][\-+]?\d+)?/,
    string: ($) =>
      seq(
        '"',
        //repeat(optional('|')),
        ".*",
        '"'
      ),
    _non_special_token: ($) =>
      choice(
        prec.right(repeat1(choice(...TOKEN_TREE_NON_SPECIAL_PUNCTUATION)))
      ),
  },
});

function sepBy(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}
