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

## Archived on 2026-05-10

### BSL real-project closure

#### T13 - Refresh BSL real-project acceptance baseline

Status: done.

Archived result:

- Re-ran the read-only RAT parser probe against
  `/home/alko/develop/open-source/rat/build/designer`.
- Recorded the refreshed baseline: 266 `.bsl` files parsed, 36 files with
  parser errors.
- Classified 12 files as grammar gaps and 24 files as source-file issues caused
  by embedded `U+FEFF` before `#Область`.
- Kept RAT checkout read-only.

#### T14 - BSL omitted-argument sequences

Status: done.

Archived result:

- Added corpus coverage for repeated omitted arguments in ordinary calls,
  method calls and constructor calls.
- Generalized BSL `arguments` so repeated positional gaps parse without
  `ERROR`, preserving visible `omitted_argument` nodes.
- Regenerated BSL parser artifacts.
- `npm run test:corpus:bsl` and `npm test` passed.

#### T15 - BSL keyword identifiers after member access

Status: done.

Archived result:

- Added corpus coverage for keyword-looking property and method names after
  member access.
- Allowed reserved keyword tokens only in post-dot member-name positions.
- Preserved global keyword handling for statement/control-flow contexts.
- Regenerated BSL parser artifacts.
- `npm run test:corpus:bsl`, `npm test` and targeted positive/negative Node
  probes passed.

#### T16 - BSL real-project acceptance closure for `v8-context`

Status: done.

Archived result:

- Re-ran the RAT parser probe after T14 and T15.
- Recorded the closure baseline: 266 `.bsl` files parsed, 24 files with parser
  errors, 0 grammar gaps.
- Classified the remaining 24 errors as embedded `U+FEFF` source-file issues in
  `tool-extensions/client_mcp/**/*.bsl`, not active BSL grammar behavior.
- `npm run test:corpus:bsl` and `npm test` passed.

### SDBL query-language grammar

#### SDBL-11 - Build full SDBL syntax coverage matrix

Status: done.

Archived result:

- Added `spec/sdbl-coverage-matrix.md`.
- Inventoried all 200 vendored `spec/sdbl-syntax/**/index.md` pages.
- Classified each page with a parser-scope decision and linked planned syntax
  gaps to concrete SDBL tasks.
- Manual exact-set cross-check and `npm run test:corpus:sdbl` passed.

#### SDBL-12 - Selection-list nested table fields and `ПУСТАЯТАБЛИЦА`

Status: done.

Archived result:

- Added corpus coverage for nested-table field groups and `ПУСТАЯТАБЛИЦА`.
- Introduced explicit parser-facing nodes for nested and empty-table field
  selection forms.
- Regenerated SDBL parser artifacts.
- Updated the SDBL coverage matrix from `planned` to `covered`.
- `npm run test:corpus:sdbl`, `npm test` and targeted Node probes passed.

#### SDBL-13 - Dedicated SDBL literal nodes

Status: done.

Archived result:

- Added corpus coverage for `ДАТАВРЕМЯ(...)`, `ТИП(...)`, `ЗНАЧЕНИЕ(...)`,
  numbers, strings, booleans, `NULL`, `НЕОПРЕДЕЛЕНО` and query parameters.
- Introduced `date_time_literal`, `type_literal`, `type_literal_name` and
  `predefined_value_literal`.
- Preserved ordinary query functions as generic `function_call`.
- Regenerated SDBL parser artifacts and updated the coverage matrix.
- `npm run test:corpus:sdbl`, `npm test` and `cargo test -q` passed.

#### SDBL-14 - Complete query function and operator catalog

Status: done.

Archived result:

- Added `grammars/sdbl/test/corpus/catalog.sdbl` coverage for documented date,
  string, math, miscellaneous, temporary-table, aggregate function and operator
  forms.
- Kept ordinary functions generic, adding only narrow syntax needed for
  `ТИПЗНАЧЕНИЯ(...)`.
- Regenerated SDBL parser artifacts and updated matrix links.
- `npm run test:corpus:sdbl` and `npm test` passed.

#### SDBL-15 - Complete query source descriptions

Status: done.

Archived result:

- Added source-description corpus closure for comma-separated sources, aliases,
  virtual table parameters, nested query sources, nested table paths and joined
  nested query sources.
- Verified existing join corpus coverage for inner, omitted-inner, left, right
  and full joins.
- Kept nested table paths as source-position `dotted_identifier` nodes without
  semantic metadata classification.
- `npm run test:corpus:sdbl` passed.

#### SDBL-16 - Complete top-level query text sections

Status: done.

Archived result:

- Added corpus coverage for top-level `ОБЪЕДИНИТЬ`, `УПОРЯДОЧИТЬ ПО`,
  `АВТОУПОРЯДОЧИВАНИЕ`, `ИТОГИ` and `ПЕРИОДАМИ(...)` variants.
- Added `totals_periods_clause`, `totals_period_unit` and
  `totals_period_bound`.
- Regenerated SDBL parser artifacts and updated the coverage matrix.
- `npm run test:corpus:sdbl` and `npm test` passed.

#### SDBL-17 - Full SDBL real-query acceptance corpus

Status: done.

Archived result:

- Added `grammars/sdbl/test/corpus/real-query-acceptance.sdbl` with curated RAT
  query snippets for source lookup, aggregate/grouped query and nested ranked
  selection.
- Kept the probe parser-facing and standalone, without analyzer facts or
  runtime behavior.
- `npm run test:corpus:sdbl` passed.
- No unsupported query syntax surfaced from the curated RAT corpus.

#### SDBL-18 - `v8-context` integration acceptance

Status: done.

Archived result:

- Verified Node binding and Rust binding checks in `tree-sitter-bsl`.
- Ran `cargo test -p analyze-bsl` in `/home/alko/develop/open-source/v8-context`.
- Confirmed stable `LANGUAGE` and `SDBL_LANGUAGE` handles and downstream
  analyzer tests against the local path dependency.

#### SDBL-19 - SDBL temporary-table `ДОБАВИТЬ` clause

Status: done.

Archived result:

- Added corpus coverage for `ДОБАВИТЬ <Имя временной таблицы>` and the
  no-alias boundary case.
- Introduced `add_clause`, `ADD_KEYWORD` and precise alias handling.
- Preserved `into_clause` and `INTO_KEYWORD` node shape.
- Regenerated SDBL parser artifacts and updated the coverage matrix.
- `npm run test:corpus:sdbl` and `npm test` passed.

#### SDBL-20 - SDBL temporary-table `УНИЧТОЖИТЬ` statement

Status: done.

Archived result:

- Added corpus coverage for standalone `УНИЧТОЖИТЬ ВременнаяТаблица`.
- Introduced statement-level `source_file` root accepting select queries and
  standalone destroy statements.
- Added parser-facing `destroy_statement` and `DESTROY_KEYWORD` nodes.
- Updated `spec/sdbl-coverage-matrix.md` and `RELEASE_NOTES.md` for the public
  root-node migration.
- `npm run test:corpus:sdbl`, `npm test` and `cargo test -q` passed.

#### SDBL-21 - Decide dedicated query function nodes vs generic `function_call`

Status: done.

Archived result:

- Reviewed current SDBL expression grammar, corpus coverage and downstream
  `v8-context` consumption.
- Decided to keep ordinary documented query functions generic as
  `function_call`.
- Kept function-family grouping, catalog lookup, arity checks and semantic
  extraction downstream unless a future syntax task proves a non-ordinary call
  shape.
- No grammar or generated artifact change was needed.
- `npm run test:corpus:sdbl` and `npm test` passed.

#### SDBL-22 - Expand real-query acceptance with WMS configuration queries

Status: done.

Archived result:

- Added `scripts/extract-sdbl-static-queries.js` as a reproducible read-only
  Node binding probe for static BSL string literals that look like SDBL.
- Ran the WMS probe against `/home/alko/develop/типовые/wms/cf/`: scanned 3552
  `.bsl` files, found 4275 candidate static query texts, parsed 2496 without
  errors and reported 1779 parser errors.
- Added deterministic WMS snippets to `real-query-acceptance.sdbl`.
- Classified grammar gaps into follow-up tasks and kept dynamic query-template
  placeholders explicit instead of adding fallback parsing.
- `npm run test:corpus:sdbl` and `npm test` passed.

#### SDBL-23 - SDBL query package texts

Status: done.

Archived result:

- Added WMS-derived corpus coverage for multiple select queries separated by
  `;` with a `//` separator comment.
- Introduced `query_package` under `source_file` while preserving single-query
  and standalone destroy roots.
- Regenerated SDBL parser artifacts and updated
  `spec/sdbl-coverage-matrix.md`, `spec/sdbl-query-language.md` and
  `RELEASE_NOTES.md`.
- `npm run test:corpus:sdbl`, `npm test`, `cargo test -q` and targeted Node
  probe passed.

#### SDBL-24 - SDBL table-valued parameter sources

Status: done.

Archived result:

- Added focused corpus coverage for parameter sources with `КАК` aliases and
  aliases without `КАК`.
- Allowed existing `parameter` nodes in source-position `table_source`
  descriptions without adding semantic validation of parameter value type or
  metadata object existence.
- Regenerated SDBL parser artifacts.
- `npm run test:corpus`, `npm test` and targeted Node parameter-source probes
  passed.

#### SDBL-25 - SDBL virtual-table omitted arguments

Status: done.

Archived result:

- Added explicit `omitted_argument` entries for virtual-table parameter lists
  without changing ordinary `expression_list` shape.
- Added WMS-style corpus coverage for leading and repeated omitted parameters.
- Regenerated standalone SDBL and Zed embedded-SDBL parser artifacts.
- `npm run test:corpus:sdbl` passed.
- The WMS raw BSL query string from `усПоложениеКонтейнеров/Ext/ManagerModule.bsl`
  lines 82-159 parsed through `sdbl_embedded` with `hasError=false`.

#### SDBL-26 - SDBL expression gaps from WMS acceptance

Status: done.

Archived result:

- Added focused corpus coverage for `ПОДОБНО` patterns built from expressions,
  `СПЕЦСИМВОЛ` values from expressions or parameters, and value-form
  `ВЫБОР <выражение> КОГДА ...` cases.
- Updated `like_expression` so pattern and escape fields expose
  `query_expression`.
- Updated `case_expression` so value-form cases can expose an optional `value`
  field while preserving searched `ВЫБОР КОГДА ...` cases.
- Regenerated SDBL parser artifacts.
- `npm run test:corpus:sdbl` and targeted Node probes for representative WMS
  expression snippets passed.

#### SDBL-27 - BSL string SDBL injection highlighting

Status: done.

Archived result:

- Added BSL `injections.scm` for static query strings beginning with
  `ВЫБРАТЬ`, `SELECT`, `УНИЧТОЖИТЬ` or `DROP`.
- Added package-level BSL and SDBL highlight queries.
- Registered SDBL in the Zed dev extension and added Zed-only
  `sdbl_embedded` grammar for raw injected BSL string carriers.
- Updated package metadata and user-facing docs so query files are shipped and
  discoverable.
- Validated injection captures, SDBL highlights, embedded parser behavior,
  `npm run test:corpus` and `npm test`.

#### SDBL-28 - SDBL index clause after filters

Status: done.

Archived result:

- Moved `index_by_clause` after optional `where_clause`, `group_by_clause` and
  `having_clause` in `select_section`.
- Replaced the negative corpus case with a positive `Select index clause after
  where` contract.
- Regenerated standalone SDBL and Zed embedded-SDBL parser artifacts.
- Validated `npm run test:corpus:sdbl` and a Zed embedded parser check for the
  WMS raw string fixture.

#### PLAYGROUND-01 - Expose BSL and SDBL playground entry points

Status: done.

Archived result:

- Kept `npm start` as the BSL playground entry point and documented
  `npm run start:bsl` / `npm run start:sdbl` as explicit per-grammar commands.
- Added separate BSL and SDBL WASM build commands plus a combined
  `npm run build:wasm` flow.
- Added focused playground examples under `examples/playground/` for BSL source
  syntax, standalone SDBL queries and semicolon-separated SDBL query packages.
- Added `parse:bsl` and `parse:sdbl` scripts for quick parse-tree checks.
- Updated README so standalone SDBL examples are not confused with BSL-string
  injection behavior.

## Archived on 2026-07-22

### SDBL grammar coverage

#### S-CAST-DEREF - Field dereference after ВЫРАЗИТЬ(...)

Status: done.

Archived result:

- Added `cast_field_access` node: `cast_expression` followed by
  `repeat1('.' field)` so `ВЫРАЗИТЬ(X КАК Справочник.Организации).Поле`
  and longer chains parse without `ERROR`; existing `cast_expression`
  node shape unchanged.
- Added corpus sections "Select cast expression with field dereference"
  and "Select cast dereference inside where condition" in
  `grammars/sdbl/test/corpus/select.sdbl`.
- Regenerated `grammars/sdbl/src` artifacts; SDBL corpus 48/48, BSL corpus
  63/63.
- Real-project probe (ЗУП 3.1.37.54, query blocks referencing
  `ГоловнаяОрганизация` that previously failed to parse): 14 of 148 blocks
  became fully clean, total `ERROR`/`MISSING` nodes dropped 1002 → 910.
  Remaining failures are dominated by report-builder brace sections
  (`{...}`) and `#Name` template substitutions — separate backlog
  candidates, not covered by this change.

#### S-REAL-CORPUS-GAPS - Tuple IN, destroy in package, nested joins

Status: done.

Archived result (one acceptance-probe batch over ЗУП 3.1.37.54 query
blocks):

- `expression_tuple` (2+ elements) allowed as `membership_expression` left
  side: `(А, Б) В (ВЫБРАТЬ ...)`, including inside virtual table
  parameters. Single-element parenthesized expression keeps its existing
  `parenthesized_expression` shape (no conflict introduced).
- `query_package` elements are now `query | destroy_statement`, so
  `УНИЧТОЖИТЬ ВТ` participates in packages instead of failing after `;`.
- `join_clause` accepts nested `join_clause` before its `ON_KEYWORD`:
  `А ЛС Б ЛС В ПО у1 ПО у2` (deferred ON conditions bind innermost-first).
  Flat join chains keep their previous shape.
- Corpus: +4 sections; SDBL suite 52/52, BSL suite 63/63.
- Real-project probe (139 prepared previously-failing ЗУП blocks): fully
  clean blocks 16 -> 111 (with S-CAST-DEREF), ERROR/MISSING 910 -> 245.
  Remaining 28 blocks are dominated by `#Name` template substitutions
  (dynamic texts, intentionally out of grammar scope).

## Archived on 2026-10-31

### SDBL grammar coverage follow-ups (PR #16 review fixes)

#### S-TUPLE-IN-RESTRICT - Restrict tuple membership operator forms

Status: done.

Archived result:

- Split `membership_expression` into two branches: a single expression
  on the left keeps accepting `value_list` and `subquery_expression` on
  the right, while `expression_tuple` (group inclusion operator,
  `(А, Б, ...) В (...)`) is only valid against a `subquery_expression`
  selecting the same number of columns. `(А, Б) В (1, 2)` now produces
  an `ERROR` node instead of a clean tree.
- Source evidence: the 1C query language group inclusion operator
  reference (1C:DN "Details on how to use the group inclusion operator")
  defines the tuple form only with a nested query on the right. The
  vendored `spec/sdbl-syntax` snapshot documents `В` and `В ИЕРАРХИИ`
  forms with a single expression on the left only.
- `В ИЕРАРХИИ` is not allowed in the tuple branch: the vendored spec
  (проверка-принадлежности-по-иерархии) requires the left side of
  `В ИЕРАРХИИ` to be a single catalog reference, which a tuple cannot
  be. `(А, Б) В ИЕРАРХИИ (ВЫБРАТЬ ...)` produces an `ERROR` node.
- A single-element parenthesized expression `(А) В (ВЫБРАТЬ ...)` still
  parses through the single-expression branch as
  `parenthesized_expression`; it is indistinguishable from ordinary
  parenthesized grouping, so accepting it is forced and not a bug.
- Node shape for valid queries is unchanged; corpus sections pin the
  rejected value-list and hierarchy forms and the NOT IN tuple form.
- Corpus: SDBL suite 57/57 (52 from S-REAL-CORPUS-GAPS plus cast
  dereference, tuple membership positive/negative/virtual-table/NOT,
  triple nested joins, flat immediate-ON join chain, hierarchy
  rejection), BSL suite 63/63.

#### Dual join-chain tree shapes (documentation)

- A join chain with immediate `ПО` after each join produces sibling
  `join_clause` nodes under `table_source`; a chain with deferred `ПО`
  conditions nests inner `join_clause` nodes inside the outer one
  before its `ON_KEYWORD` (innermost-first binding). Consumers walking
  joins must handle both shapes; both are pinned by corpus sections
  ("Select flat join chain with immediate on conditions", "Select
  nested joins with deferred on conditions", "Select triple nested
  joins with deferred on conditions").

#### CI pins (operational contract)

- CI pins the tree-sitter CLI to 0.25.10 (must equal the
  `package.json` pin at every artifact regeneration), the Windows
  runner to `windows-2022`, and uses `macos-latest`. `windows-2022`
  and the CLI pin must be revisited when GitHub retires the image or
  when artifacts are regenerated with a newer CLI.
- `go-tree-sitter` is pinned to v0.25.0 for ABI 15 support; do not
  downgrade below it while parsers are generated with ABI 15.

#### Grammar naming and structure review (PR #16, review round 2)

Node renames applied while the nodes are new (no external consumers):
- `expression_tuple` -> `group_inclusion_tuple` (role-anchored name from
  the 1C group inclusion operator; distinguishes from `value_list` and
  `expression_list` by name alone).
- `cast_field_access` -> `cast_dereference` (matches the 1C "разыменование
  полей" term, removes the collision with the select-list `field` node).
- `SPECIALCHAR_KEYWORD` -> `ESCAPE_KEYWORD` (official bilingual keyword
  table: СПЕЦСИМВОЛ = ESCAPE).
- `TYPE_VALUE_FUNCTION_NAME` -> `VALUE_TYPE_FUNCTION_NAME` (official
  bilingual table: ТИПЗНАЧЕНИЯ = VALUETYPE).
- `source_file` and the zed sdbl-embedded adapter's `source_file` now use
  `choice($.query_package, $._package_element)` instead of restating the
  package element set.

Decisions recorded:
- `cast_dereference` stays a separate node from `cast_expression`
  (reviewer verified folding it into `cast_expression` as a postfix is
  technically possible with no conflicts; keeping two nodes lets
  consumers match "cast with dereference" separately from plain casts).
  A node-shape migration to a folded form would require corpus and
  consumer updates and is not planned.
- Deferred-ON join chains have a third reachable tree shape besides the
  two documented above (flat siblings, nested chain): a join may contain
  multiple nested sibling joins plus its own ON condition. Consumers
  walking joins must recurse and handle sibling lists at every level.
- `_virtual_table_parameter_list` is load-bearing as written: replacing
  it with a flat separator form regresses 7 corpus sections (middle
  omitted arguments stop parsing) due to the `expression_list`
  competition; do not simplify without a node-shape migration.
- Known rejection (intentional, do not file as bug): a virtual table
  parameter list with a trailing comma after two or more parameters,
  e.g. `Курсы(&А, &Б,)`, is rejected; single trailing commas parse.
- Known rejection (intentional, do not file as bug): a single query with
  a trailing semicolon (`ВЫБРАТЬ 1 ИЗ Т;`) is rejected; packages require
  two or more elements.
- Backlog candidates: `membership_expression` rename to `in_expression`
  (10+ corpus occurrences, needs deliberate migration), consistent
  field naming for join sources (`source` vs `name`), `HIERARCHY_KEYWORD`
  accepts both "иерархии" and "иерархия" word forms (leniency),
  `GENERAL_KEYWORD` name vs OVERALL alias mismatch.

## Archived on 2026-11-01

### SDBL corpus consolidation (PR #13 review follow-ups, branch pr13-clean)

#### S-CORPUS-SPLIT - Topic-split the SDBL corpus

Status: done.

Archived result:

- `select.sdbl` grew to 47 sections / 3127 lines, so it was split by topic
  without renaming sections or changing expected trees. Verified
  programmatically: the union of the split files equals the original 47
  sections byte-for-byte modulo one inter-section separator newline
  (the former last section gained a trailing blank line as a separator
  in `join.sdbl`), no duplicates.
- Final corpus layout after the split and the review pinning round (76
  sections total, all green): `select.sdbl` 31 (general select clauses,
  literals, sources, virtual-table parameters), `join.sdbl` 7 (join kinds
  and flat, nested and mixed join-chain tree shapes), `cast.sdbl` 5 (`ВЫРАЗИТЬ` and
  `cast_dereference` forms), `membership.sdbl` 12 (`В` operator and
  `group_inclusion_tuple` forms), `query-package.sdbl` 6 (packages and
  `УНИЧТОЖИТЬ` statements), `catalog.sdbl` 4, `real-query-acceptance.sdbl`
  11 (3 RAT + 3 WMS + 5 reconstructed ЗУП-pattern acceptance sections).
- Updated `spec/sdbl-coverage-matrix.md` references from `select.sdbl` to
  the focused topic files where the sections moved (join, cast, membership,
  destroy/package).

#### S-REVIEW-PINS - Corpus pins for review findings REV-1..REV-6, REV-9

Status: done.

Archived result (+19 sections across the T2 pinning round and T3 acceptance
fixtures; SDBL suite 76/76, BSL suite 63/63, `npm test` 2/2):

- Join-chain tree shapes: added "Select mixed join chain with nested then
  flat segments" and "Select flat then nested join chain" (`join.sdbl`).
  Together with the existing flat and nested sections this pins flat,
  nested and mixed join-chain tree shapes (deep chains can interleave
  these shapes at every level; the pinned sections cover each class,
  not every interleaving).
- Known rejection pinned: parenthesized cast dereference
  (`(ВЫРАЗИТЬ(...)).Поле`) produces an `ERROR` node on the dot between
  field and field_alias ("Select parenthesized cast dereference is
  rejected", `cast.sdbl`). Not fixed deliberately: a fix needs a node-shape
  migration and there are no consumers of the rejected form.
- English keyword variants pinned: cast dereference
  ("Select cast dereference in english keywords", `cast.sdbl`), tuple
  membership with subquery and tuple value-list rejection
  (`membership.sdbl`).
- Membership behavior pinned in `membership.sdbl`: single-element
  parenthesized expression on the left of `В` parses as
  `parenthesized_expression` (no `group_inclusion_tuple`; forced, the form
  is indistinguishable from ordinary grouping); tuple arity mismatch
  against a wider subquery parses cleanly (known leniency: column-count
  matching is semantic validation, out of grammar scope); tuple membership
  is accepted as a join `ПО` condition ("Select tuple membership in join
  on condition").
- Package behavior pinned in `query-package.sdbl`: destroy-first and
  destroy-only packages parse cleanly (known leniency: in real 1C a
  destroy-only package is doubtful, but the grammar intentionally allows
  any `query | destroy_statement` sequence); a package of 2+ queries with
  a trailing `;` parses as `query_package`; a single query with a trailing
  `;` is rejected ("Single query with trailing semicolon is rejected").
- Virtual-table trailing comma pinned in `select.sdbl`: with two or more
  actual parameters a trailing comma is rejected
  ("Select virtual table parameters trailing comma after two parameters
  is rejected"); a lone trailing comma still parses as `omitted_argument`
  (verified by a Node binding probe; the positive lone-trailing-comma
  branch is not pinned by a corpus section — see the backlog item in
  `spec/IMPLEMENTATION_TODO.md`).

#### S-ACCEPTANCE-FIXTURES - ЗУП-pattern acceptance sections (REV-3)

Status: done.

Archived result:

- Added 5 sections prefixed `Acceptance real query:` to
  `real-query-acceptance.sdbl`, one per previously-unpinned ЗУП pattern:
  cast dereference on organization hierarchy, group inclusion tuple in a
  filter, temporary-table package with destroy, nested joins with deferred
  `ПО` conditions, tuple membership inside virtual-table parameters.
- Honest provenance: these are sanitized deterministic reconstructions of
  the patterns described in the archived `S-REAL-CORPUS-GAPS` probe, not
  verbatim blocks extracted from a ЗУП checkout. The ЗУП checkout was not
  available on the working host during this round, so the archived
  "16 -> 111 clean blocks" statement remains a one-off manual probe
  without a reproducible rerun.
- Naming rule for acceptance sections (fixed here): the prefix
  `Acceptance real query:` marks a sanitized reconstruction of a real
  product pattern; `RAT real query:` / `WMS real query:` prefixes mark
  blocks extracted from the corresponding product checkouts.
- Maintenance-cost tradeoff (accepted at review): acceptance sections
  deliberately overlap the focused unit sections of the same features;
  the value is fidelity to real query composition, not new syntax
  coverage.
- Expected trees were captured from actual `tree-sitter parse` output
  (coordinates and statistics stripped); `tree-sitter test -u`
  auto-update was not used.
