# tree-sitter-bsl implementation todo

This file tracks parser work in this repository. The current BSL backlog was
discovered from comparing this project with
`/home/alko/develop/open-source/lezer-bsl`. The SDBL backlog tracks the new
1C query-language grammar accepted in
`docs/decisions/0001-add-sdbl-query-language-grammar.md`.

## Scope

Current BSL goal: improve `tree-sitter-bsl` grammar coverage and regression tests by
porting useful BSL cases from `lezer-bsl`, while keeping the tree-sitter AST
contract and the existing structured preprocessor model.

SDBL goal: add a standalone `sdbl` grammar for the 1C query language in this
same repository, while keeping BSL parsing unchanged until a later accepted
integration contract defines embedded query parsing for BSL strings.

Non-goals:

- Do not replace the structured `#Если` / `#Область` parser with a generic
  skipped preprocessor-line token.
- Do not copy Lezer AST node names or visitor APIs as-is.
- Do not treat the current `lezer-bsl` test suite as a green oracle. Its
  repository currently contains many failing spec expectations; use its input
  snippets as corpus candidates and define tree-sitter-specific S-expressions.
- Do not parse SDBL inside BSL string literals in the initial SDBL grammar
  work.
- Do not add analyzer facts, diagnostics, metadata models, HBK facts, query
  tools, report formats or downstream product behavior to grammar scope.

## Validation baseline

- `npm test` verifies that the Node binding loads.
- `tree-sitter test` is the intended corpus validation command.
- Current local blocker: `node_modules/tree-sitter-cli/tree-sitter` requires
  `GLIBC_2.39` on this host, so the CLI must be repaired or replaced before
  the full corpus can be validated locally.
- The system `tree-sitter` CLI is available in this checkout and can run
  `tree-sitter test`; the package-local CLI blocker above still applies to
  `node_modules/tree-sitter-cli/tree-sitter`.
- For quick probes until then, use the Node binding and check
  `tree.rootNode.hasError` on targeted snippets.

## Now

### T01 - Add parser corpus for imported Lezer cases

Status: done.

Source: `lezer-bsl/tests/spec/*.txt`.

Work:

- Add focused corpus files or sections for the BSL snippets below before
  changing grammar behavior.
- Keep expected trees in the current tree-sitter style.
- Prefer small sections grouped by syntax feature instead of one large imported
  dump.

Acceptance:

- New corpus cases document every grammar change in this ledger.
- No test expectation depends on Lezer node naming.
- Added `test/corpus/lezer-imported-gaps.bsl` with focused sections for the
  imported expression, statement, access/call, argument and variable-declaration
  snippets.

Validation:

- `tree-sitter test` when the local CLI is available.
- Temporary Node binding probes are acceptable only while the CLI is blocked.

### T02 - Parenthesized expressions

Status: done.

Problem:

- `Возврат (а + б);` currently produces parser errors.

Work:

- Add a `parenthesized_expression` expression node.
- Preserve precedence for examples such as `(1 + 2) * 3`.

Acceptance:

- `Возврат (1 + 2);` parses without `ERROR`.
- `Возврат (1 + 2) * 3;` preserves the intended grouping.
- Added `parenthesized_expression` and regenerated parser artifacts.

### T03 - Empty statements and repeated semicolons

Status: done.

Problem:

- `;;;а = 1;` and `а = 1;;;б = 2;` currently produce `ERROR`.

Work:

- Allow repeated semicolons at module level and inside blocks.
- Keep the last statement without semicolon supported.

Acceptance:

- Empty statements do not create syntax errors.
- Control structures still parse normally without a semicolon before their
  closing keyword.
- Added hidden `_empty_statement` coverage for repeated semicolons at module
  level and inside `Если ... КонецЕсли` blocks.

### T04 - `ВызватьИсключение` rethrow semantics

Status: done.

Problem:

- `ВызватьИсключение;` is valid only as rethrow inside the `Исключение` branch
  of `Попытка ... Исключение ... КонецПопытки`.
- A broad optional argument on the generic raise statement would incorrectly
  accept invalid BSL outside exception handlers.

Work:

- Split generic statement parsing from exception-branch statement parsing if
  needed.
- Keep ordinary `ВызватьИсключение <expression>` and
  `ВызватьИсключение(<args>)` available where they are valid.
- Add a context-specific no-argument rethrow form only inside the `Исключение`
  branch.

Acceptance:

- This parses:

```bsl
Попытка
    Действие();
Исключение
    ВызватьИсключение;
КонецПопытки
```

- A standalone `ВызватьИсключение;` outside an exception branch is not accepted
  as a valid no-argument statement.
- Added context-specific exception-branch rethrow parsing while keeping generic
  `rise_error_statement` argument-bearing outside exception branches.
- Added corpus coverage for bare rethrow, invalid standalone bare raise,
  expression raise and argument-list raise.
- Regenerated BSL parser artifacts.

### T05 - `Выполнить` expression coverage

Status: done.

Problem:

- `Выполнить Объект.Метод();` currently produces parser errors.

Work:

- Make the `Выполнить` operator accept the same expression forms used by other
  statement contexts.
- Preserve the distinction between the operator `Выполнить <expression>` and a
  method call such as `Запрос.Выполнить()`.

Acceptance:

- `Выполнить Объект.Метод();` parses without `ERROR`.
- `Выполнить Объект.Метод1().Метод2();` parses without `ERROR`.
- `Запрос.Выполнить();` remains a call statement, not an execute operator.
- Added focused `test/corpus/execute.bsl` coverage for object-method and
  chained-method expressions after the `Выполнить` operator.
- Current grammar already satisfied the T05 syntax behavior; no grammar or
  generated artifact changes were required.

## Next

### T06 - Access and call chains after index access

Status: done.

Problem:

- `результат = Объект["Метод"](параметр);` currently fails after parsing the
  string index.

Work:

- Support calls after index access.
- Cover chained member/index/call combinations from `lezer-bsl`
  `property-by-string` and `call-stmt` cases.

Acceptance:

- `Объект["Свойство"]` parses as index/member access.
- `Объект["Метод"](параметр)` parses as a call expression.
- Existing property and method-chain trees remain stable where practical.
- Added focused `test/corpus/access.bsl` coverage for assignment and call
  statement forms after string index access, plus chained
  call/property/index access.
- Updated the imported Lezer gap corpus from the previous explicit `ERROR`
  expectation to the tree-sitter `call_expression` shape.
- Regenerated BSL parser artifacts; `call_expression`/`access` node types now
  admit direct `arguments` after index access.

### T07 - Empty arguments in calls

Status: done.

Problem:

- `Метод(а,,б);` and `Метод(,а,);` currently produce parser errors.

Work:

- Decide and document whether omitted arguments are valid for BSL call
  expressions in the supported language target.
- If valid, represent omitted arguments explicitly enough for downstream
  analyzers to distinguish them from absent syntax.

Acceptance:

- The decision is covered by corpus tests.
- If implemented, empty arguments parse without `ERROR`.
- Omitted call arguments are valid BSL syntax and are represented by named
  `omitted_argument` nodes in `arguments` so positional gaps remain visible.
- Added corpus coverage for middle and edge omitted arguments and regenerated
  BSL parser artifacts.

### T08 - Per-variable `Экспорт` in `Перем`

Status: done.

Problem:

- `Перем а, б Экспорт, в;` currently fails because `Экспорт` is accepted only
  after the whole variable list.

Work:

- Introduce a variable-spec shape for declarations.
- Preserve compatibility with `Перем а, б, в Экспорт;` if that form is valid in
  the target BSL syntax.

Acceptance:

- Mixed export declarations are covered by corpus tests.
- Existing module-level and local variable declarations continue to parse.
- Added `variable_spec` nodes for module-level variable declarations so
  per-variable `Экспорт` is attached to the exported variable while final
  `Экспорт` remains the declaration-level export form.
- Updated `test/corpus/lezer-imported-gaps.bsl` coverage for mixed and whole
  declaration export forms and regenerated BSL parser artifacts.

## Later

### T09 - Annotation attachment model

Status: planned.

Problem:

- Compilation annotations currently parse as standalone preprocessor nodes.
  Analyzer consumers may need them attached to the following procedure,
  function, or variable declaration.

Work:

- Evaluate whether changing attachment is worth the AST compatibility cost.
- If changed, document the node-shape migration in release notes.

Acceptance:

- `&НаКлиенте` before a procedure can be discovered from that procedure's
  subtree or through a documented sibling rule.

### T10 - Date literals with separators

Status: planned.

Problem:

- `lezer-bsl` accepts date literals such as
  `'2017.03.23 10:45:25'` and `'2017\03\23-10~45~25'`.
- The current grammar accepts only compact date literals.

Work:

- Verify these forms against real BSL behavior before broadening the token.
- Add tests for accepted and rejected date forms.

Acceptance:

- Only platform-valid date literal forms are accepted.

### T11 - String literal and multiline-string regression set

Status: planned.

Work:

- Import useful multiline string and adjacent string cases from
  `lezer-bsl/tests/spec/multiline-string.txt`.
- Keep tree-sitter tokenization behavior stable for existing multiline-string
  corpus.

Acceptance:

- Indented `|` continuation lines keep parsing.
- Escaped double quotes remain covered.

### T12 - Real-project acceptance corpus

Status: planned.

Work:

- Use `/home/alko/develop/open-source/rat` as a read-only acceptance corpus
  once grammar tasks above are in place.
- Do not mutate the RAT checkout during parser validation.

Acceptance:

- A documented command parses selected RAT `.bsl` files and reports parser
  errors.
- Known unsupported cases are tracked explicitly instead of hidden in ad-hoc
  probes.

## SDBL query-language grammar

Decision:

- `docs/decisions/0001-add-sdbl-query-language-grammar.md`

Specification:

- `spec/sdbl-query-language.md`
- `spec/sdbl-source-evidence.md`

Source:

- `spec/sdbl-syntax/`

### SDBL-01 - Record SDBL architecture and parser contract

Status: done.

Work:

- Accept the in-repository `sdbl` grammar decision.
- Record SDBL grammar scope, non-goals, source evidence, expected layout,
  validation commands and staged implementation milestones.

Acceptance:

- ADR index exists under `docs/decisions/`.
- The accepted ADR records why SDBL is separate from BSL but remains in the same
  repository.
- The SDBL spec records the MVP parser contract and explicitly defers BSL string
  injection.

### SDBL-02 - Scaffold standalone SDBL grammar

Status: done.

Work:

- Add `grammars/sdbl/grammar.js`.
- Add the initial `grammars/sdbl/test/corpus/*.sdbl` corpus file before grammar
  behavior.
- Generate SDBL parser artifacts under `grammars/sdbl/src/`.
- Add the SDBL grammar entry to `tree-sitter.json` after the scaffold is proven
  locally.

Acceptance:

- `tree-sitter generate --output grammars/sdbl/src grammars/sdbl/grammar.js`
  succeeds from the repository root.
- `tree-sitter test -p grammars/sdbl` runs the initial SDBL corpus.
- `tree-sitter test` still protects the existing BSL corpus from the repository
  root.
- Added `grammars/sdbl/grammar.js`,
  `grammars/sdbl/test/corpus/select.sdbl`, generated SDBL artifacts under
  `grammars/sdbl/src/` and the `sdbl` entry in `tree-sitter.json`.

### SDBL-03 - Implement MVP `ВЫБРАТЬ` / `ИЗ` / `ГДЕ`

Status: done.

Work:

- Cover the MVP examples from `spec/sdbl-query-language.md` with corpus tests.
- Implement case-insensitive query keywords, dotted identifiers, selection
  fields, aliases, plain table sources, literals, parameters and basic boolean
  conditions.
- Keep later syntax such as joins, nested queries, totals and BSL string
  injection explicit in this ledger.

Acceptance:

- MVP standalone query texts parse without `ERROR`.
- Expected trees define SDBL node shapes in tree-sitter style.
- BSL node shapes remain unchanged.
- Added focused corpus coverage for field lists, `РАЗРЕШЕННЫЕ`,
  `РАЗЛИЧНЫЕ`, `ПЕРВЫЕ`, aliases, `ИЗ`, `ГДЕ`, dotted identifiers,
  parameters, literals and basic boolean/comparison expressions.
- Regenerated SDBL artifacts under `grammars/sdbl/src/`.

### SDBL-04 - Complete select-section optional clauses

Status: planned.

Source:

- `spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/index.md`

Work:

- Add corpus coverage for `ПОМЕСТИТЬ`, `ИНДЕКСИРОВАТЬ ПО`,
  `СГРУППИРОВАТЬ ПО`, `ИМЕЮЩИЕ` and `ДЛЯ ИЗМЕНЕНИЯ`.
- Preserve the documented clause order from the source snapshot.
- Keep clause nodes explicit instead of absorbing unsupported syntax into a
  generic skipped token.

Acceptance:

- Queries with each supported optional select-section clause parse without
  `ERROR`.
- Incorrect clause order is not accepted just to make broad snippets parse.
- SDBL generated artifacts are regenerated after grammar changes.

### SDBL-05 - Add source descriptions, virtual tables and joins

Status: planned.

Source:

- `spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-из/index.md`

Work:

- Add table-source corpus cases for virtual-table parameters.
- Add nested-query and nested-table source corpus cases.
- Add explicit join rules for inner, left outer, right outer and full outer
  joins with `ПО <Условие отбора>`.

Acceptance:

- Source lists remain comma-separated where the language requires that shape.
- Join node shapes expose join kind, source and condition.
- Nested query parsing reuses the SDBL query-description rules.

### SDBL-06 - Expand query expressions and logical operators

Status: planned.

Source:

- `spec/sdbl-syntax/использование-выражений-в-языке-запросов/index.md`

Work:

- Add arithmetic, unary, parenthesized and precedence-sensitive expression
  corpus cases.
- Add query logical operators: `В`, `МЕЖДУ`, `ПОДОБНО`, `ЕСТЬ NULL` and
  `ССЫЛКА`.
- Add list-of-values and subquery membership cases where documented by the
  source snapshot.

Acceptance:

- Expression precedence is represented by stable tree-sitter node shapes.
- Unsupported expression forms remain explicit in the ledger.
- Existing MVP expression trees remain stable where practical.

### SDBL-07 - Add query functions, aggregate functions and special forms

Status: planned.

Source:

- `spec/sdbl-syntax/использование-выражений-в-языке-запросов/функции-языка-запросов/index.md`
- `spec/sdbl-syntax/использование-выражений-в-языке-запросов/агрегатные-функции/index.md`
- `spec/sdbl-syntax/использование-выражений-в-языке-запросов/операция-выбора-выбор/index.md`
- `spec/sdbl-syntax/использование-выражений-в-языке-запросов/приведение-типа-выразить/index.md`

Work:

- Add function-call coverage for documented query-language functions.
- Add aggregate-function coverage for selection, grouping and having contexts.
- Add explicit grammar for `ВЫБОР` and `ВЫРАЗИТЬ`.

Acceptance:

- Function and aggregate calls parse through SDBL expression rules.
- `ВЫБОР` and `ВЫРАЗИТЬ` have dedicated nodes, not generic function-call nodes.
- No semantic validation of function argument types is added.

### SDBL-08 - Add top-level union, ordering, auto-ordering and totals

Status: planned.

Source:

- `spec/sdbl-syntax/текст-запроса/index.md`
- `spec/sdbl-syntax/текст-запроса/секция-объединить-все-объединение-запросов/index.md`
- `spec/sdbl-syntax/текст-запроса/секция-упорядочить-по-упорядочивание-результатов/index.md`
- `spec/sdbl-syntax/текст-запроса/автоупорядочивание/index.md`
- `spec/sdbl-syntax/текст-запроса/секция-итоги-описание-итогов/index.md`

Work:

- Add top-level corpus cases for `ОБЪЕДИНИТЬ`, `ОБЪЕДИНИТЬ ВСЕ`,
  `УПОРЯДОЧИТЬ ПО`, `АВТОУПОРЯДОЧИВАНИЕ` and `ИТОГИ`.
- Preserve the documented top-level section order.
- Cover ordering direction, hierarchy ordering and totals aliases where the
  source snapshot documents those forms.

Acceptance:

- Full query texts with optional top-level sections parse without `ERROR`.
- Top-level section nodes remain distinct from select-section clauses.

### SDBL-09 - Define and implement SDBL binding/package exposure

Status: planned.

Work:

- Decide how Node, Rust, Python, Go and C surfaces expose the second grammar.
- Update binding code and package metadata only after the standalone SDBL parser
  is stable.
- Add binding tests that prove BSL and SDBL languages can both be loaded.

Acceptance:

- Existing BSL binding consumers remain compatible unless a release note
  explicitly documents a breaking change.
- SDBL binding tests cover the public loading API.
- `npm test` remains green after binding changes.

### SDBL-10 - Design future BSL string injection

Status: planned.

Work:

- Define how embedded query strings in BSL are detected.
- Decide whether injection is implemented through tree-sitter queries,
  downstream composition, or a later grammar-level integration.
- Record accepted behavior in a follow-up ADR before implementation.

Acceptance:

- No BSL AST shape is changed before the integration contract is accepted.
- Injection false positives and unsupported dynamic-string cases are documented
  before implementation.
