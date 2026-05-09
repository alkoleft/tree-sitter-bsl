# tree-sitter-bsl completed implementation archive

This file archives completed parser-work items that were moved out of the
active `spec/IMPLEMENTATION_TODO.md` ledger. Keep this file historical: new
work belongs in `spec/IMPLEMENTATION_TODO.md` until it is completed and
accepted.

## Archived on 2026-05-09

### BSL grammar coverage

#### T01 - Add parser corpus for imported Lezer cases

Status: done.

Archived result:

- Added `grammars/bsl/test/corpus/lezer-imported-gaps.bsl` with focused
  sections for imported expression, statement, access/call, argument and
  variable-declaration snippets.
- Kept tree-sitter-specific expected trees instead of Lezer node names.

#### T02 - Parenthesized expressions

Status: done.

Archived result:

- Added `parenthesized_expression`.
- Covered `Возврат (1 + 2);` and `(1 + 2) * 3`.
- Regenerated BSL parser artifacts.

#### T03 - Empty statements and repeated semicolons

Status: done.

Archived result:

- Added hidden `_empty_statement` coverage for repeated semicolons at module
  level and inside blocks.
- Kept control-structure parsing stable without requiring a semicolon before a
  closing keyword.

#### T04 - `ВызватьИсключение` rethrow semantics

Status: done.

Archived result:

- Added context-specific bare `ВызватьИсключение;` parsing only inside
  `Исключение` branches.
- Kept ordinary argument-bearing `ВызватьИсключение` available elsewhere.
- Covered bare rethrow, invalid standalone bare raise, expression raise and
  argument-list raise.
- Regenerated BSL parser artifacts.

#### T05 - `Выполнить` expression coverage

Status: done.

Archived result:

- Added `grammars/bsl/test/corpus/execute.bsl` coverage for object-method and
  chained-method expressions after `Выполнить`.
- Confirmed existing grammar already satisfied the behavior; no grammar or
  generated artifact changes were required.

#### T06 - Access and call chains after index access

Status: done.

Archived result:

- Added corpus coverage for assignment and call-statement forms after string
  index access, plus chained call/property/index access.
- Updated imported gap corpus from explicit `ERROR` expectation to the
  supported `call_expression` shape.
- Regenerated BSL parser artifacts.

#### T07 - Empty arguments in calls

Status: done.

Archived result:

- Accepted omitted call arguments as valid BSL syntax.
- Represented positional gaps with named `omitted_argument` nodes.
- Added corpus coverage for middle and edge omitted arguments.
- Regenerated BSL parser artifacts.

#### T08 - Per-variable `Экспорт` in `Перем`

Status: done.

Archived result:

- Added `variable_spec` nodes for module-level variable declarations.
- Supported per-variable `Экспорт` and the whole-declaration export form.
- Updated imported gap corpus and regenerated BSL parser artifacts.

#### T09 - Annotation attachment model

Status: done.

Archived result:

- Preserved the existing sibling rule to avoid a public node-shape migration:
  one or more annotation/preprocessor nodes immediately preceding a procedure,
  function or module variable declaration apply to that declaration.
- Added focused preprocessor corpus coverage.

#### T10 - Date literals with separators

Status: done.

Archived result:

- Added coverage for compact, dot/space/colon, mixed-separator and
  minute-precision date literals.
- Rejected incomplete, odd-precision and hour-only precision date literals.
- Kept the public `date` node shape unchanged.
- Regenerated BSL parser artifacts.

#### T11 - String literal and multiline-string regression set

Status: done.

Archived result:

- Added coverage for escaped quotes, indented `|` continuation lines, `|//`
  text inside multiline strings, assignment-side multiline strings and the
  current parser contract that adjacent quoted strings are not implicit
  concatenation.
- Existing grammar already satisfied the supported behavior.

#### T12 - Real-project acceptance corpus

Status: done.

Archived result:

- Added `scripts/parse-bsl-files.js`, a read-only Node binding probe for
  selected `.bsl` files or directories.
- Recorded the original RAT validation command against
  `/home/alko/develop/open-source/rat/build/designer`.
- Original archived baseline: 266 `.bsl` files parsed, 105 files with parser
  errors.
- Later analysis on 2026-05-09 observed an improved live baseline of 36 files
  with parser errors, so the active ledger should track the refreshed baseline
  before declaring acceptance coverage complete.

### Repository layout

#### LAYOUT-01 - Move BSL grammar under `grammars/bsl`

Status: done.

Archived result:

- Moved BSL source grammar, generated artifacts and corpus files under
  `grammars/bsl/`.
- Kept public parser symbols and binding entry points unchanged.
- Updated build metadata, package manifests, specs and agent rules to reference
  `grammars/bsl/`.
- `tree-sitter.json` now contains explicit `path` entries for both `bsl` and
  `sdbl`.

### SDBL query-language grammar

#### SDBL-01 - Record SDBL architecture and parser contract

Status: done.

Archived result:

- Accepted the in-repository standalone `sdbl` grammar decision.
- Recorded SDBL grammar scope, non-goals, source evidence, expected layout,
  validation commands and staged implementation milestones.
- Kept initial BSL string injection deferred.

#### SDBL-02 - Scaffold standalone SDBL grammar

Status: done.

Archived result:

- Added `grammars/sdbl/grammar.js`.
- Added `grammars/sdbl/test/corpus/select.sdbl`.
- Generated SDBL artifacts under `grammars/sdbl/src/`.
- Added the `sdbl` entry to `tree-sitter.json`.

#### SDBL-03 - Implement MVP `ВЫБРАТЬ` / `ИЗ` / `ГДЕ`

Status: done.

Archived result:

- Added focused corpus coverage for field lists, `РАЗРЕШЕННЫЕ`,
  `РАЗЛИЧНЫЕ`, `ПЕРВЫЕ`, aliases, `ИЗ`, `ГДЕ`, dotted identifiers,
  parameters, literals and basic boolean/comparison expressions.
- Regenerated SDBL artifacts.

#### SDBL-04 - Complete select-section optional clauses

Status: done.

Archived result:

- Added coverage for `ПОМЕСТИТЬ`, `ИНДЕКСИРОВАТЬ ПО`,
  `СГРУППИРОВАТЬ ПО`, `ИМЕЮЩИЕ`, `ДЛЯ ИЗМЕНЕНИЯ` with and without table
  lists, and rejected `ИНДЕКСИРОВАТЬ ПО` after `ГДЕ`.
- Added explicit clause/list nodes in documented select-section order.
- Regenerated SDBL artifacts.

#### SDBL-05 - Add source descriptions, virtual tables and joins

Status: done.

Archived result:

- Added corpus coverage for virtual-table parameters, nested query sources,
  nested table sources, inner joins, left/right/full outer join kinds and
  repeated joins.
- Added explicit `virtual_table_source`, `virtual_table_parameters`,
  `nested_query_source`, `join_clause` and `join_kind` nodes.
- Regenerated SDBL artifacts.

#### SDBL-06 - Expand query expressions and logical operators

Status: done.

Archived result:

- Added coverage for arithmetic precedence, unary signs, parenthesized
  expressions, list/subquery membership, `МЕЖДУ`, `ПОДОБНО`, `ЕСТЬ NULL` and
  `ССЫЛКА`.
- Added explicit expression nodes for these constructs.
- Regenerated SDBL artifacts.

#### SDBL-07 - Add query functions, aggregate functions and special forms

Status: done.

Archived result:

- Added coverage for documented query-language functions, aggregate functions
  in selection and having contexts, `ВЫБОР` and `ВЫРАЗИТЬ`.
- Added explicit `function_call`, `function_arguments`, `aggregate_function`,
  `aggregate_function_name`, `case_expression`, `case_when_clause`,
  `case_else_clause`, `cast_expression` and `cast_type` nodes.
- Regenerated SDBL artifacts.

#### SDBL-08 - Add top-level union, ordering, auto-ordering and totals

Status: done.

Archived result:

- Added coverage for `ОБЪЕДИНИТЬ`, `ОБЪЕДИНИТЬ ВСЕ`,
  `УПОРЯДОЧИТЬ ПО`, `АВТОУПОРЯДОЧИВАНИЕ`, `ИТОГИ`, ordering direction,
  hierarchy ordering and totals aliases.
- Added explicit top-level section nodes in documented query-text order.
- Regenerated SDBL artifacts.

#### SDBL-09 - Define and implement SDBL binding/package exposure

Status: done.

Archived result:

- Kept default BSL entry points unchanged.
- Added SDBL exposure through Node (`sdbl` language object), Rust
  (`SDBL_LANGUAGE` / `SDBL_NODE_TYPES`), Python (`SDBLLanguage()` /
  `sdbl_language()`), Go (`SDBLLanguage()`) and C (`tree_sitter_sdbl()`).
- Updated package/build metadata so supported builds compile both generated
  parser artifacts.
- `npm test` remained green after binding changes.

#### SDBL-10 - Design future BSL string injection

Status: done.

Archived result:

- Added ADR-0002 to define future injection through parser composition based
  on tree-sitter injections, not a BSL grammar merge.
- Detection is limited to statically recoverable BSL string content that begins
  with `ВЫБРАТЬ` or `SELECT` after BSL string normalization.
- Dynamic string construction remains explicitly unsupported.
