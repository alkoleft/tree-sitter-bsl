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

Status: planned.

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

### T05 - `Выполнить` expression coverage

Status: planned.

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

## Next

### T06 - Access and call chains after index access

Status: planned.

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

### T07 - Empty arguments in calls

Status: planned.

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

### T08 - Per-variable `Экспорт` in `Перем`

Status: planned.

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
