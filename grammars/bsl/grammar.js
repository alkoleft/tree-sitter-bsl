/// <reference types='tree-sitter-cli/dsl' />

const PREC = {
  LOGICAL_OR: 10,
  LOGICAL_AND: 11,
  COMPARISON: 13,
  ADDITIVE: 14,
  MULTIPLICATIVE: 15,
  UNARY: 16,
  ACCESS: 17,
  CALL: 18,
  NEW: 19,
  TERNARY: 20,
  ASSIGNMENT: 21,
  AWAIT: 22,
};

const keyword = (...words) => token(choice(...words.map(caseInsensitive)));
const caseInsensitive = (word) => new RegExp(word, 'i');

const CORE_KEYWORDS = [
  // Control flow
  ['если', 'if'],
  ['тогда', 'then'],
  ['иначеесли', 'elsif'],
  ['иначе', 'else'],
  ['конецесли', 'endif'],
  ['для', 'for'],
  ['каждого', 'each'],
  ['из', 'in'],
  ['по', 'to'],
  ['пока', 'while'],
  ['цикл', 'do'],
  ['конеццикла', 'enddo'],
  ['перейти', 'goto'],
  ['возврат', 'return'],
  ['прервать', 'break'],
  ['продолжить', 'continue'],

  // Declarations
  ['процедура', 'procedure'],
  ['функция', 'function'],
  ['конецпроцедуры', 'endprocedure'],
  ['конецфункции', 'endfunction'],
  ['перем', 'var'],
  ['экспорт', 'export'],
  ['знач', 'val'],

  // Values
  ['истина', 'true'],
  ['ложь', 'false'],
  ['неопределено', 'undefined'],

  // Exceptions
  ['попытка', 'try'],
  ['исключение', 'except'],
  ['вызватьисключение', 'raise'],
  ['конецпопытки', 'endtry'],

  // Async/await
  ['асинх', 'async'],
  ['ждать', 'await'],

  // New
  ['новый', 'new'],

  // Handlers
  ['добавитьобработчик', 'addhandler'],
  ['удалитьобработчик', 'removehandler'],

  // Operators
  ['и', 'and'],
  ['или', 'or'],
  ['не', 'not'],
];

const PREPROC_KEYWORDS = [
  ['если', 'if'],
  ['иначеесли', 'elsif'],
  ['иначе', 'else'],
  ['конецесли', 'endif'],
  ['область', 'region'],
  ['конецобласти', 'endregion'],
];

/**
 * Module-level definitions для параметра level хелпера statementSequence:
 * самозавершающиеся элементы уровня, живущие без `;`.
 *
 * @param {*} $ grammar object
 */
const moduleLevelDefs = ($) => [
  $.procedure_definition,
  $.function_definition,
  $.var_definition,
];

/**
 * Формирует правила для ключевых слов
 */
function buildKeywords() {
  const kw = {};
  for (const [rus, eng] of CORE_KEYWORDS) {
    kw[`${eng.toUpperCase()}_KEYWORD`] = ($) => keyword(rus, eng);
  }

  for (const [rus, eng] of PREPROC_KEYWORDS) {
    kw[`PREPROC_${eng.toUpperCase()}_KEYWORD`] = ($) =>
      keyword('#' + rus, '#' + eng);
  }

  kw['NULL_KEYWORD'] = ($) => token(/null/i);
  return kw;
}

/**
 * Формирует список резервируемых слов
 *
 * @param {*} $ grammar object
 */
function reservedKeywords($) {
  return Object.keys(buildKeywords()).map((k) => $[k]);
}

const Preprocessor = {
  preprocessor: ($) => {
    const region = seq(
      $.PREPROC_REGION_KEYWORD,
      field('name', $.identifier),
      statementSequence($, {
        level: moduleLevelDefs($),
      }),
      $.PREPROC_ENDREGION_KEYWORD,
    );

    const preproc_if = seq(
      $.PREPROC_IF_KEYWORD,
      $.expression,
      $.THEN_KEYWORD,
      statementSequence($, {
        level: moduleLevelDefs($),
      }),
      repeat(
        seq(
          $.PREPROC_ELSIF_KEYWORD,
          $.expression,
          $.THEN_KEYWORD,
          statementSequence($, {
            level: moduleLevelDefs($),
          }),
        ),
      ),
      optional(seq($.PREPROC_ELSE_KEYWORD, statementSequence($, {
        level: moduleLevelDefs($),
      }))),
      $.PREPROC_ENDIF_KEYWORD,
    );

    const preproc_change = [
      'Вставка',
      'Insert',
      'КонецВставки',
      'EndInsert',
      'Удаление',
      'Delete',
      'КонецУдаления',
      'EndDelete',
    ].map((annotation) =>
      alias(token(caseInsensitive('#' + annotation)), $.preproc),
    );

    const annotations = [
      'Перед',
      'Before',
      'После',
      'After',
      'Вместо',
      'Around',
      'ИзменениеИКонтроль',
      'ChangeAndValidate',
    ].map((annotation) =>
      seq(
        alias(token(caseInsensitive('&' + annotation)), $.annotation),
        '(',
        $.string,
        ')',
      ),
    );
    const compilation_directives = [
      'НаКлиенте',
      'AtClient',
      'НаСервере',
      'AtServer',
      'НаСервереБезКонтекста',
      'AtServerNoContext',
      'НаКлиентеНаСервереБезКонтекста',
      'AtClientAtServerNoContext',
      'НаКлиентеНаСервере',
      'AtClientAtServer',
    ].map((annotation) =>
      alias(token(caseInsensitive('&' + annotation)), $.annotation),
    );
    return choice(
      region,
      preproc_if,
      ...preproc_change,
      ...annotations,
      ...compilation_directives,
    );
  },
};

module.exports = grammar({
  name: 'bsl',

  extras: ($) => [/\s/, $.line_comment],

  supertypes: ($) => [],

  inline: ($) => [],

  conflicts: ($) => [
    // `~Метка:`-statement vs binary-expression с identifier — GLR нужен для
    // разделения уровней при `;`-разделительной модели.
    [$._statement],
    // region/preproc_if повторяют preprocessor и statements разных уровней —
    // GLR разрешает вложение preproc-директив друг в друга.
    [$.preprocessor],
    // `;` внутри region — empty-statement уровня region, а не statement-
    // обёртка: GLR разводит интерпретации до #КонецОбласти.
    [$.preprocessor, $._statement],
    // Тело Попытки vs ветка Исключение: после statement без `;` парсер не
    // знает, начался ли except-body — GLR держит обе ветки до EXCEPT_KEYWORD.
    [$.try_statement],
    // Если...КонецЕсли: trailing statement без `;` неотличим от начала
    // следующего statement того же уровня — GLR до ENDIF_KEYWORD.
    [$.if_statement],
    // Тело Пока...КонецЦикла: та же trailing/следующий-statement неоднозначность.
    [$.while_statement],
    // Тела procedure/function: последний statement без `;` перед
    // ENDPROCEDURE/ENDFUNCTION — GLR до ключевого слова конца.
    [$.procedure_definition],
    [$.function_definition],
    // Тела циклов Для — trailing statement без `;` перед КонецЦикла.
    [$.for_statement],
    [$.for_each_statement],
    // Иначе/ИначеЕсли-ветки: statement-тело ветки без `;` перед следующим
    // ELSIF/ELSE/ENDIF — GLR до ключевого слова ветки.
    [$.else_clause],
    [$.elseif_clause],
    // `Перем а, б Экспорт;` vs `Перем а;` — export-спекификация неразличима
    // до запятой/`;` (исходный конфликт, не связан с разделителями).
    [$._plain_variable_spec, $._exported_variable_spec],
    // source_file допускает statements и definitions вперемешку — GLR
    // разрешает порядок уровней module-level.
    [$.source_file],
    // `;` в начале/конце файла — это empty-statement уровня source_file,
    // а не statement-обёртка: GLR разводит интерпретации.
    [$.source_file, $._statement],
    // statement без `;` может быть и хвостом блока, и элементом внешнего
    // уровня — GLR нужен на каждой вложенности блоков.
    [$._statement, $.try_statement],
    [$._statement, $.if_statement],
    [$._statement, $.while_statement],
    [$._statement, $.else_clause],
    [$._statement, $.procedure_definition],
    [$._statement, $.function_definition],
  ],

  word: ($) => $.identifier,

  reserved: {
    global: ($) => reservedKeywords($),
  },
  rules: {
    source_file: ($) => statementSequence($, {
      level: moduleLevelDefs($),
    }),

    procedure_definition: ($) =>
      seq(
        optional($.ASYNC_KEYWORD),
        $.PROCEDURE_KEYWORD,
        field('name', $.identifier),
        field('parameters', $.parameters),
        optional(field('export', $.EXPORT_KEYWORD)),
        statementSequence($),
        $.ENDPROCEDURE_KEYWORD,
      ),

    function_definition: ($) =>
      seq(
        optional($.ASYNC_KEYWORD),
        $.FUNCTION_KEYWORD,
        field('name', $.identifier),
        field('parameters', $.parameters),
        optional(field('export', $.EXPORT_KEYWORD)),
        statementSequence($),
        $.ENDFUNCTION_KEYWORD,
      ),

    var_definition: ($) =>
      prec.right(
        1,
        seq(
          $.VAR_KEYWORD,
          $._var_definition_variables,
          optional(field('export', $.EXPORT_KEYWORD)),
        ),
      ),
    _var_definition_variables: ($) =>
      seq(
        repeat(
          choice(
            seq(
              field('variable', alias($._exported_variable_spec, $.variable_spec)),
              ',',
            ),
            seq(
              field('variable', alias($._plain_variable_spec, $.variable_spec)),
              ',',
            ),
          ),
        ),
        field('variable', alias($._plain_variable_spec, $.variable_spec)),
      ),
    _plain_variable_spec: ($) =>
      prec(2, seq(field('name', $.identifier))),
    _exported_variable_spec: ($) =>
      prec(
        2,
        seq(
          field('name', $.identifier),
          field('export', $.EXPORT_KEYWORD),
        ),
      ),
    parameters: ($) => seq('(', commaSep(field('parameter', $.parameter)), ')'),

    parameter: ($) =>
      seq(
        field('val', optional($.VAL_KEYWORD)),
        field('name', $.identifier),
        optional(seq('=', field('def', $._const_value))),
      ),

    // Statements
    _statement: ($) =>
      choice(
        $._terminated_statement,
        $.empty_statement,
      ),

    // Все statements, которые разделяются `;` (разделительная модель:
    // `;` обязателен между statements одного уровня блока, последний
    // statement уровня может быть без `;`). Добавление нового statement,
    // который разделяется `;`, — строка в этом choice.
    //
    // НЕ входят сюда (самостоятельные элементы уровня, без `;`):
    // `label_statement` (`~Метка:`), `preprocessor` (`#Область`, `&НаКлиенте`),
    // `procedure_definition` / `function_definition` / `var_definition`
    // (module level), `empty_statement` (`;`).
    _terminated_statement: ($) =>
      choice(
        $.execute_statement,
        $.call_statement,
        $.assignment_statement,
        $.return_statement,
        $.rise_error_statement,
        $.var_statement,
        $.continue_statement,
        $.break_statement,
        $.goto_statement,
        $.add_handler_statement,
        $.remove_handler_statement,
        $.await_statement,
        $.try_statement,
        $.if_statement,
        $.while_statement,
        $.for_statement,
        $.for_each_statement,
      ),

    // NAMED-узел: пустой `;` виден в дереве как (empty_statement).
    // В разделительной модели интерпретация `;` структурная: repeat-ветка
    // seq(statement, ';') против самостоятельной ветки $.empty_statement
    // в statementSequence — отдельный прецедент не нужен.
    empty_statement: ($) => ';',

    call_statement: ($) =>
      seq(choice($.method_call, $.call_expression)),

    assignment_statement: ($) =>
      seq(
        field('left', $._assignment_member),
        '=',
        field('right', $.expression),
      ),

    return_statement: ($) =>
      seq($.RETURN_KEYWORD, field('result', optional($.expression))),

    try_statement: ($) =>
      seq(
        $.TRY_KEYWORD,
        statementSequence($),
        $.EXCEPT_KEYWORD,
        statementSequence($, {statement: $._exception_statement}),
        $.ENDTRY_KEYWORD,
      ),

    _exception_statement: ($) => $._statement,

    // ВызватьИсключение без выражения — валидный re-raise в 1С не только внутри
    // блока Исключение (issue #24: 35 файлов ssl_3_2). Выражение и `;` опциональны:
    // re-raise работает и в обычной statement-позиции, и как последний оператор
    // блока Исключение без разделителя (#14). Отдельный alias-узел
    // _rise_error_rethrow_statement больше не нужен: rise_error_statement
    // покрывает обе формы, дерево остаётся rise_error_statement (RAISE_KEYWORD).
    rise_error_statement: ($) =>
      seq($.RAISE_KEYWORD, optional(choice(prec(1, $.arguments), $.expression))),

    var_statement: ($) =>
      seq(
        $.VAR_KEYWORD,
        sepBy1(',', field('var_name', $.identifier)),
      ),

    if_statement: ($) =>
      seq(
        $.IF_KEYWORD,
        $.expression,
        $.THEN_KEYWORD,
        statementSequence($),
        repeat($.elseif_clause),
        optional($.else_clause),
        $.ENDIF_KEYWORD,
      ),

    elseif_clause: ($) =>
      seq($.ELSIF_KEYWORD, $.expression, $.THEN_KEYWORD, statementSequence($)),

    else_clause: ($) => seq($.ELSE_KEYWORD, statementSequence($)),

    while_statement: ($) =>
      seq(
        $.WHILE_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        statementSequence($),
        $.ENDDO_KEYWORD,
      ),

    for_statement: ($) =>
      seq(
        $.FOR_KEYWORD,
        $.identifier,
        '=',
        $.expression,
        $.TO_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        statementSequence($),
        $.ENDDO_KEYWORD,
      ),

    for_each_statement: ($) =>
      seq(
        $.FOR_KEYWORD,
        $.EACH_KEYWORD,
        $.identifier,
        $.IN_KEYWORD,
        $.expression,
        $.DO_KEYWORD,
        statementSequence($),
        $.ENDDO_KEYWORD,
      ),

    continue_statement: ($) => seq($.CONTINUE_KEYWORD),

    break_statement: ($) => seq($.BREAK_KEYWORD),

    // keyword() inline — сознательно: Выполнить в 1С не reserved и остаётся
    // валидным identifier'ом; НЕ переносить в CORE_KEYWORDS без смены
    // контракта. Внутренние prec.right разрешают неоднозначность двух форм
    // (с параметром и без) — это реальная нагрузка, не рудимент.
    execute_statement: ($) => choice(
      prec.right(seq(keyword('выполнить', 'execute'), $.expression)),
      prec.right(1, seq(keyword('выполнить', 'execute'), '(', $.expression, ')')),
    ),

    goto_statement: ($) =>
      seq($.GOTO_KEYWORD, '~', $.identifier),

    label_statement: ($) => seq('~', $.identifier, ':'),

    add_handler_statement: ($) =>
      seq($.ADDHANDLER_KEYWORD, $.expression, ',', $.expression),

    remove_handler_statement: ($) =>
      seq(
        $.REMOVEHANDLER_KEYWORD,
        $.expression,
        ',',
        $.expression,
      ),
    await_statement: ($) => seq($.await_expression),

    // Expressions
    expression: ($) =>
      choice(
        $._non_unary_expression,
        $.unary_expression,
        $.binary_expression,
      ),

    unary_expression: ($) =>
      prec.left(
        PREC.UNARY,
        seq(
          field('operator', alias(choice('-', '+', $.NOT_KEYWORD), $.operator)),
          // операнд ЛЮБОГО унарного оператора (-, +, НЕ) не может быть
          // другим унарным выражением: `--а`, `Не Не а`, `-Не а`, `Не -а`
          // без скобок — невалидный 1С; скобки снимают ограничение:
          // `-(-а)`, `Не (Не а)`, `-(Не а)` — валидны.
          // alias в $.expression сохраняет обёртку argument: (expression ...)
          field('argument', alias($._non_unary_expression, $.expression)),
        ),
      ),

    // expression без унарной формы (единый список для -/+/НЕ);
    // alias в $.expression сохраняет привычную обёртку argument: (expression ...)
    // binary_expression здесь сознательно отсутствует: PREC.UNARY >
    // PREC.ADDITIVE, поэтому `-а + 1` парсится как бинарное с унарным
    // левым операндом, и унарному оператору незачем напрямую оборачивать
    // бинарное без скобок — иначе лазейка пропускает двойной унарный
    // знак без ERROR (`--а + 1`). Список переиспользуется самим
    // `expression` выше — отдельной синхронной копии больше нет.
    _non_unary_expression: ($) =>
      choice(
        alias($._const_value, $.const_expression),
        $.identifier,
        $.parenthesized_expression,
        $.ternary_expression,
        $.new_expression,
        $.new_expression_method,
        $.method_call,
        $.call_expression,
        $.property_access,
        $.await_expression,
      ),

    parenthesized_expression: ($) => seq('(', $.expression, ')'),

    binary_expression: ($) => {
      const operations = [
        [PREC.LOGICAL_AND, $.AND_KEYWORD],
        [PREC.LOGICAL_OR, $.OR_KEYWORD],
        [PREC.COMPARISON, choice('<>', '=', '>', '<', '>=', '<=')],
        [PREC.ADDITIVE, choice('+', '-')],
        [PREC.MULTIPLICATIVE, choice('*', '/', '%')],
      ];

      return choice(
        ...operations.map(([priority, operator]) => {
          return prec.left(
            priority,
            seq(
              field('left', $.expression),
              field('operator', alias(operator, $.operator)),
              field('right', $.expression),
            ),
          );
        }),
      );
    },

    ternary_expression: ($) =>
      prec.right(
        seq(
          '?',
          '(',
          field('condition', $.expression),
          ',',
          field('consequence', $.expression),
          ',',
          field('alternative', $.expression),
          ')',
        ),
      ),

    new_expression: ($) =>
      prec(
        PREC.NEW,
        seq(
          $.NEW_KEYWORD,
          field('type', $.identifier),
          field('arguments', optional($.arguments)),
        )),
    new_expression_method: ($) =>
      prec.right(
        PREC.NEW,
        seq(
          $.NEW_KEYWORD,
          '(',
          field('type', $.expression),
          choice(seq(',', field('arguments', $.expression), ')'), ')'),
        )),

    call_expression: ($) => prec(PREC.CALL - 1, $._access_call),

    await_expression: ($) =>
      prec(PREC.AWAIT, seq($.AWAIT_KEYWORD, $.expression)),

    _assignment_member: ($) => choice($.identifier, $.property_access),

    property_access: ($) =>
      prec(PREC.ACCESS, choice($._access_property, $._access_index)),

    access: ($) =>
      prec(
        1,
        choice(
          $._access_call,
          $._access_index,
          $._access_property,
          $.identifier,
          $.method_call,
        ),
      ),
    _access_call: ($) => choice(
      seq($.access, '.', alias($._access_method_call, $.method_call)),
      seq(choice($._access_index, $._access_call), $.arguments),
    ),
    _access_index: ($) => seq($.access, '[', alias($.expression, $.index), ']'),
    // После `.` имя свойства — ВСЕГДА member_name-токен (идентично identifier
    // по regex, но без reserved-механизма): ключевые слова 1С (Функция,
    // Неопределено и т.п.) здесь — имена свойств, а не keyword-узлы.
    _access_property: ($) =>
      seq(
        $.access,
        '.',
        alias($.member_name, $.property),
      ),

    method_call: ($) =>
      prec(
        PREC.CALL,
        seq(field('name', $.identifier), field('arguments', $.arguments)),
      ),

    // method-call после точки: имя — member_name-токен (keyword-имена
    // допустимы), алиас в identifier даёт чистый name: (identifier) узел.
    _access_method_call: ($) =>
      prec(
        PREC.CALL,
        seq(
          field('name', alias($.member_name, $.identifier)),
          field('arguments', $.arguments),
        ),
      ),

    member_name: ($) =>
      // regex зеркалит identifier (включая ё/Ё).
      //
      // Precedence-инвариант (контракт, не деталь): prec(-1) существует
      // НЕ ради after-dot выигрыша (после `.` у member_name нет лексических
      // конкурентов), а чтобы member_name проигрывал keyword- и
      // identifier-токенам (prec 0) в error-mode лексинге вне expression-
      // контекста. Если member_name начинает выигрывать вне after-dot
      // позиции, слова невалидного ввода лексируются как property, который
      // не валиден на старте statement — recovery теряет точку resync и
      // глотает весь statement в один ERROR.
      //
      // Guards (corpus):
      //  - draft-coverage.bsl «НЕ НЕ с вызовом — невалидный BSL» —
      //    recovery-restart: ERROR только на `НЕ НЕ`, далее чистый
      //    call_statement с method_call;
      //  - access.bsl / methods.bsl keyword-member секции — after-dot
      //    выигрыш: `Структура.Функция` → property, `Структура.Функция()` →
      //    method_call name: identifier. При добавлении нового keyword
      //    расширять эти секции, чтобы after-dot-выигрыш оставался
      //    запинирован.
      //
      // Чувствительность: error-mode лексинг зависит от версии
      // tree-sitter-runtime; пины актуальны для CLI 0.27.x (так же, как
      // различие MISSING/ERROR между 0.25 и 0.27, зафиксированное в
      // RELEASE_NOTES).
      token(prec(-1, /[\wа-яёЁ_][\wа-яёЁ_0-9]*/i)),

    arguments: ($) =>
      prec(
        1,
        seq(
          '(',
          optional($._argument_list),
          ')',
        ),
      ),
    _argument_list: ($) =>
      prec.right(
        1,
        choice(
          $.expression,
          seq($.expression, ',', $._argument_list),
          seq($.expression, alias(',', $.omitted_argument)),
          seq(alias(',', $.omitted_argument), optional($._argument_list)),
        ),
      ),

    // Primitive
    ...buildKeywords(),
    ...Preprocessor,

    _const_value: ($) =>
      choice(
        $.number,
        $.date,
        $.string,
        alias($.multiline_string, $.string),
        $.boolean,
        $.UNDEFINED_KEYWORD,
        $.NULL_KEYWORD,
      ),

    boolean: ($) => choice($.TRUE_KEYWORD, $.FALSE_KEYWORD),

    number: ($) => /\d+(\.\d+)?/,
    date: ($) =>
      /'\d{4}[^0-9'\r\n]*\d{2}[^0-9'\r\n]*\d{2}([^0-9'\r\n]*\d{2}[^0-9'\r\n]*\d{2}([^0-9'\r\n]*\d{2})?)?'/,
    string: ($) =>
      seq(
        '"',
        alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
        '"',
      ),
    multiline_string: ($) =>
      seq(
        '"',
        alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
        repeat1(
          seq(
            '|',
            alias(token.immediate(prec(1, /([^\r\n"]|"")*/)), $.string_content),
          ),
        ),
        '"',
      ),
    identifier: ($) => /[\wа-яёЁ_][\wа-яёЁ_0-9]*/i,

    line_comment: ($) => seq('//', /[^\r\n]*/),
  },
});

/**
 * Creates a rule to optionally match one or more of the rules separated by a comma
 *
 * @param {RuleOrLiteral} rule
 */
function commaSep(rule) {
  return sepBy(',', rule);
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

/**
 * Строит DSL-выражение «блок statements с разделителем `;`» для контейнеров
 * (тела процедур/функций/блоков, source_file, region/preproc_if).
 *
 * Разделительная модель: `;` обязателен между statements ОДНОГО уровня
 * (в repeat-ветке statement идёт только в паре с `;`); последний statement
 * уровня может быть без `;` (trailing optional). Семантика уровней: цепочка
 * закрывающих ключевых слов вложенных блоков (`Возврат 1 КонецЕсли
 * КонецЦикла`) идёт без `;`, т.к. каждый эндер закрывает свой уровень и
 * последний statement уровня оказывается trailing.
 *
 * Не named-правило, а хелпер: named-nullable-правило запрещено DSL
 * (matches empty string) — см. образец sepBy/commaSep.
 *
 * @param {*} $ grammar object
 *
 * @param {object} [extra] переопределения контейнера
 *
 * @param {*} [extra.statement] подмена statement-правила для обеих позиций
 * (например `$._exception_statement` для ветки Исключение — rethrow-alias
 * + обычные statements)
 *
 * @param {Array} [extra.level] самостоятельные элементы уровня, живущие
 * без `;` и в repeat-, и в trailing-позиции (module-level definitions
 * на уровне source_file и внутри region/preproc_if)
 *
 * Новый контейнер statements: добавь вызов statementSequence — generate
 * сам потребует недостающие GLR-конфликты (по образцу существующих
 * контейнеров в conflicts()).
 */
function statementSequence($, extra = {}) {
  const seqStmt = extra.statement ?? $._terminated_statement;
  const lastStmt = extra.statement ?? $._statement;
  const level = extra.level ?? [];
  return prec.right(seq(
    repeat(choice(
      seq(seqStmt, ';'),
      $.empty_statement,
      $.label_statement,
      $.preprocessor,
      ...level)),
    optional(choice(lastStmt, $.label_statement, $.preprocessor, ...level))));
}
