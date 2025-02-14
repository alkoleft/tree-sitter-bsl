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
  IF_KEYWORD: ($) => keyword("если", "if"),

  THEN_KEYWORD: ($) => keyword("тогда", "then"),

  ELSE_IF_KEYWORD: ($) => keyword("иначеесли", "elsif"),

  ELSE_KEYWORD: ($) => keyword("иначе", "else"),

  END_IF_KEYWORD: ($) => keyword("конецесли", "endif"),

  FOR_KEYWORD: ($) => keyword("для", "for"),

  EACH_KEYWORD: ($) => keyword("каждого", "each"),

  IN_KEYWORD: ($) => keyword("из", "in"),

  TO_KEYWORD: ($) => keyword("по", "to"),

  WHILE_KEYWORD: ($) => keyword("пока", "while"),

  DO_KEYWORD: ($) => keyword("цикл", "do"),

  END_DO_KEYWORD: ($) => keyword("конеццикла", "enddo"),

  PROCEDURE_KEYWORD: ($) => keyword("процедура", "procedure"),

  FUNCTION_KEYWORD: ($) => keyword("функция", "function"),

  END_PROCEDURE_KEYWORD: ($) => keyword("конецпроцедуры", "endprocedure"),

  END_FUNCTION_KEYWORD: ($) => keyword("конецфункции", "endfunction"),

  VAR_KEYWORD: ($) => keyword("перем", "var"),

  GOTO_KEYWORD: ($) => keyword("перейти", "goto"),

  RETURN_KEYWORD: ($) => keyword("возврат", "return"),

  CONTINUE_KEYWORD: ($) => keyword("продолжить", "continue"),

  BREAK_KEYWORD: ($) => keyword("прервать", "break"),

  AND_KEYWORD: ($) => keyword("и", "and"),

  OR_KEYWORD: ($) => keyword("или", "or"),

  NOT_KEYWORD: ($) => keyword("не", "not"),

  TRY_KEYWORD: ($) => keyword("попытка", "try"),

  EXCEPT_KEYWORD: ($) => keyword("исключение", "except"),

  RAISE_KEYWORD: ($) => keyword("вызватьисключение", "raise"),

  END_TRY_KEYWORD: ($) => keyword("конецпопытки", "endtry"),

  NEW_KEYWORD: ($) => keyword("новый", "new"),

  EXECUTE_KEYWORD: ($) => keyword("выполнить", "execute"),

  ADD_HANDLER_KEYWORD: ($) => keyword("добавитьобработчик", "addhandler"),

  REMOVE_HANDLER_KEYWORD: ($) => keyword("удалитьобработчик", "removehandler"),

  VAL_KEYWORD: ($) => keyword("знач", "val"),

  TRUE_KEYWORD: ($) => keyword("истина", "true"),

  FALSE_KEYWORD: ($) => keyword("ложь", "false"),

  NULL_KEYWORD: ($) => /(null)/i,

  UNDEFINED_KEYWORD: ($) => keyword("неопределено", "undefine"),

  EXPORT_KEYWORD: ($) => keyword("экспорт", "export"),

  PREPROC_IF_KEYWORD: ($) => keyword("#если", "#if"),
  PREPROC_ELSE_IF_KEYWORD: ($) => keyword("#иначеесли", "#elsif"),
  PREPROC_ELSE_KEYWORD: ($) => keyword("#иначе", "#else"),
  PREPROC_END_IF_KEYWORD: ($) => keyword("#конецесли", "#endif"),
  PREPROC_REGION_START_KEYWORD: ($) => keyword("#область", "#region"),
  PREPROC_REGION_END_KEYWORD: ($) => keyword("#конецобласти", "#endregion"),

  ASYNC_KEYWORD: ($) => keyword("асинх", "async"),
  AWAIT_KEYWORD: ($) => keyword("ждать", "await"),
};

const Operations = {
  operation: ($) => {
    const boolOperation = [$.AND_KEYWORD, $.OR_KEYWORD];
    const compareOperation = ["<>", "=", ">", "<", ">=", "<="];
    const arithmeticOperation = ["+", "-", "*", "/", "%"];
    return choice(
      ...boolOperation,
      ...arithmeticOperation,
      ...compareOperation
    );
  },
};

const Preprocessor = {
  preprocessor: ($) => {
    const region = [
      seq($.PREPROC_REGION_START_KEYWORD, $.identifier),
      $.PREPROC_REGION_END_KEYWORD,
    ];

    const preproc_if = [
      seq($.PREPROC_IF_KEYWORD, $.expression, $.THEN_KEYWORD),
      seq($.PREPROC_ELSE_IF_KEYWORD, $.expression, $.THEN_KEYWORD),
      $.PREPROC_ELSE_KEYWORD,
      $.PREPROC_END_IF_KEYWORD,
    ];

    const preproc_change = [
      "Вставка",
      "Insert",
      "КонецВставки",
      "EndInsert",
      "Удаление",
      "Delete",
      "КонецУдаления",
      "EndDelete",
    ].map((annotation) =>
      alias(token(caseInsensitive("#" + annotation)), $.preproc)
    );

    const annotations = [
      "Перед",
      "Before",
      "После",
      "After",
      "Вместо",
      "Around",
      "ИзменениеИКонтроль",
      "ChangeAndValidate",
    ].map((annotation) =>
      seq(
        alias(token(caseInsensitive("&" + annotation)), $.annotation),
        "(",
        $.string,
        ")"
      )
    );
    const compilation_directives = [
      "НаКлиенте",
      "AtClient",
      "НаСервере",
      "AtServer",
      "НаСервереБезКонтекста",
      "AtServerNoContext",
      "НаКлиентеНаСервереБезКонтекста",
      "AtClientAtServerNoContext",
      "НаКлиентеНаСервере",
      "AtClientAtServer",
    ].map((annotation) =>
      alias(token(caseInsensitive("&" + annotation)), $.annotation)
    );
    return choice(
      ...region,
      ...preproc_if,
      ...preproc_change,
      ...annotations,
      ...compilation_directives
    );
  },
};

module.exports = grammar({
  name: "bsl",

  extras: ($) => [/\s/, $.line_comment],

  supertypes: ($) => [$.statement],

  inline: ($) => [],

  conflicts: ($) => [],

  word: ($) => $.identifier,

  rules: {
    source_file: ($) => repeat($._definition),

    _definition: ($) =>
      choice(
        $.procedure_definition,
        $.function_definition,
        $.var_definition,
        $.statement
      ),

    procedure_definition: ($) =>
      seq(
        optional($.ASYNC_KEYWORD),
        $.PROCEDURE_KEYWORD,
        field("name", $.identifier),
        field("parameters", $.parameters),
        optional(field("export", $.EXPORT_KEYWORD)),
        repeat($.statement),
        $.END_PROCEDURE_KEYWORD
      ),

    function_definition: ($) =>
      seq(
        optional($.ASYNC_KEYWORD),
        $.FUNCTION_KEYWORD,
        field("name", $.identifier),
        field("parameters", $.parameters),
        optional(field("export", $.EXPORT_KEYWORD)),
        repeat($.statement),
        $.END_FUNCTION_KEYWORD
      ),

    var_definition: ($) =>
      prec(
        1,
        seq(
          $.VAR_KEYWORD,
          sepBy1(",", field("var_name", $.identifier)),
          optional(field("export", $.EXPORT_KEYWORD)),
          optional(";")
        )
      ),
    parameters: ($) =>
      seq("(", sepBy(",", field("parameter", $.parameter)), ")"),

    parameter: ($) =>
      seq(
        field("val", optional($.VAL_KEYWORD)),
        field("name", $.identifier),
        field("def", optional($._def_value))
      ),

    _def_value: ($) => seq("=", $._const_value),

    // Statements
    statement: ($) =>
      choice(
        $.call_statement,
        $.assignment_statement,
        $.return_statement,
        $.try_statement,
        $.rise_error_statement,
        $.var_statement,
        $.if_statement,
        $.while_statement,
        $.for_statement,
        $.for_each_statement,
        $.continue_statement,
        $.break_statement,
        $.execute_statement,
        $.goto_statement,
        $.label_statement,
        $.add_handler_statement,
        $.remove_handler_statement,
        $.preprocessor,
        $.await_statement
      ),

    call_statement: ($) => seq($.call_expression, optional(";")),

    assignment_statement: ($) =>
      seq(
        field("left", $._assignment_member),
        "=",
        field("right", $.expression),
        optional(";")
      ),

    return_statement: ($) =>
      prec.right(seq($.RETURN_KEYWORD, optional($.expression), optional(";"))),

    try_statement: ($) =>
      seq(
        $.TRY_KEYWORD,
        repeat($.statement),
        $.EXCEPT_KEYWORD,
        repeat($.statement),
        $.END_TRY_KEYWORD,
        optional(";")
      ),

    rise_error_statement: ($) =>
      seq($.RAISE_KEYWORD, choice($.arguments, $.expression), optional(";")),

    var_statement: ($) =>
      seq(
        $.VAR_KEYWORD,
        sepBy1(",", field("var_name", $.identifier)),
        optional(";")
      ),

    if_statement: ($) =>
      seq(
        $.IF_KEYWORD,
        $.expression,
        $.THEN_KEYWORD,
        repeat($.statement),
        repeat(
          seq(
            $.ELSE_IF_KEYWORD,
            $.expression,
            $.THEN_KEYWORD,
            repeat($.statement)
          )
        ),
        optional($.else),
        $.END_IF_KEYWORD,
        optional(";")
      ),

    else_if: ($) =>
      seq($.ELSE_IF_KEYWORD, $.expression, $.THEN_KEYWORD, repeat($.statement)),

    else: ($) => seq($.ELSE_KEYWORD, repeat($.statement)),

    while_statement: ($) =>
      seq(
        $.WHILE_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        repeat($.statement),
        $.END_DO_KEYWORD
      ),

    for_statement: ($) =>
      seq(
        $.FOR_KEYWORD,
        $.assignment_statement,
        $.TO_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        repeat($.statement),
        $.END_DO_KEYWORD,
        optional(";")
      ),

    for_each_statement: ($) =>
      seq(
        $.FOR_KEYWORD,
        $.EACH_KEYWORD,
        $.identifier,
        $.IN_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        repeat($.statement),
        $.END_DO_KEYWORD,
        optional(";")
      ),
    continue_statement: ($) => seq($.CONTINUE_KEYWORD, optional(";")),

    break_statement: ($) => seq($.BREAK_KEYWORD, optional(";")),

    execute_statement: ($) =>
      seq($.EXECUTE_KEYWORD, "(", $.expression, ")", optional(";")),

    goto_statement: ($) =>
      seq($.GOTO_KEYWORD, "~", $.identifier, optional(";")),

    label_statement: ($) => seq("~", $.identifier, ":", optional(";")),

    add_handler_statement: ($) =>
      seq(
        $.ADD_HANDLER_KEYWORD,
        $.expression,
        ",",
        $.expression,
        optional(";")
      ),

    remove_handler_statement: ($) =>
      seq(
        $.REMOVE_HANDLER_KEYWORD,
        $.expression,
        ",",
        $.expression,
        optional(";")
      ),
    await_statement: ($) => seq($.await_expression, optional(";")),

    // Expressions
    expression: ($) =>
      choice(
        alias($._const_value, $.const_expression),
        $.identifier,
        $.unary_expression,
        $.binary_expression,
        $.ternary_expression,
        $.new_expression,
        $.call_expression,
        $.property_access,
        $.await_expression
      ),
    unary_expression: ($) =>
      prec.left(
        seq(
          field("operator", alias(choice("-", "+", $.NOT_KEYWORD), $.operation)),
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

    new_expression: ($) =>
      choice(
        prec.right(
          0,
          seq(
            $.NEW_KEYWORD,
            field("type", $.identifier),
            field("arguments", optional($.arguments))
          )
        ),
        seq($.NEW_KEYWORD, field("arguments", $.arguments))
      ),

    call_expression: ($) =>
      prec(
        2,
        choice(
          $.method_call,
          seq(alias($.identifier, $.property), repeat($._access), ".", $.method_call),
          seq($.method_call, repeat($._access), ".", $.method_call)
        )
      ),

    await_expression: ($) => prec(1, seq($.AWAIT_KEYWORD, $.expression)),

    _assignment_member: ($) =>
      choice(
        $.identifier,
        $.property_access
      ),

    property_access: ($) => seq(choice($.identifier, $.method_call), repeat1($._access)),

    _access: ($) => choice($._access_call, $._access_index, $._access_property),
    _access_call: ($) => seq(".", $.method_call),
    _access_index: ($) => seq("[", alias($.expression, $.index), "]"),
    _access_property: ($) => seq(".", alias($.identifier, $.property)),

    method_call: ($) =>
      seq(field("name", $.identifier), field("arguments", $.arguments)),

    arguments: ($) => seq("(", sepBy(",", $.expression), ")"),

    // Primitive
    ...Keywords,
    ...Operations,
    ...Preprocessor,

    _const_value: ($) =>
      choice(
        $.number,
        $.date,
        $.string,
        alias($.multiline_string, $.string),
        $.boolean,
        $.UNDEFINED_KEYWORD,
        $.NULL_KEYWORD
        //TODO Date
      ),

    boolean: ($) => choice($.TRUE_KEYWORD, $.FALSE_KEYWORD),
    null: ($) => $.NULL_KEYWORD,

    number: ($) => /\d+(\.\d+)?/,
    date: ($) => /'\d{8,14}'/,
    string: ($) =>
      seq(
        '"',
        alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
        '"'
      ),
    multiline_string: ($) =>
      seq(
        '"',
        alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
        repeat1(
          seq(
            "|",
            alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content)
          )
        ),
        '"'
      ),
    identifier: ($) => /[\wа-я_][\wа-я_0-9]*/i,

    line_comment: ($) => seq("//", /.*/),
    _non_special_token: ($) =>
      choice(
        prec.right(repeat1(choice(...TOKEN_TREE_NON_SPECIAL_PUNCTUATION)))
      ),
  },
});

/**
 * Creates a rule to match one or more of the rules separated by a comma
 *
 * @param {RuleOrLiteral} rule
 */
function commaSep1(rule) {
  return sepBy1(",", rule);
}

/**
 * Creates a rule to optionally match one or more of the rules separated by a comma
 *
 * @param {RuleOrLiteral} rule
 */
function commaSep(rule) {
  return sepBy(",", rule);
}

/**
 * Creates a rule to optionally match one or more of the rules separated by a separator
 *
 * @param {RuleOrLiteral} sep
 *
 * @param {RuleOrLiteral} rule
 */
function sepBy(sep, rule) {
  return optional(sepBy1(sep, rule));
}

/**
 * Creates a rule to match one or more of the rules separated by a separator
 *
 * @param {RuleOrLiteral} sep
 *
 * @param {RuleOrLiteral} rule
 */
function sepBy1(sep, rule) {
  return seq(rule, repeat(seq(sep, rule)));
}

function keyword(...words) {
  return token(choice(...words.map(caseInsensitive)));
}

function caseInsensitive(word) {
  return new RegExp(word, "i");
}
