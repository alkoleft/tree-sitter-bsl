# tree-sitter-bsl implementation todo

This file tracks active parser work in this repository. Completed parser-work
items are archived in `spec/IMPLEMENTATION_ARCHIVE.md`.

The current BSL backlog was discovered from comparing this project with
`/home/alko/develop/open-source/lezer-bsl` and from read-only real-project
acceptance probes. The SDBL backlog tracks the 1C query-language grammar
accepted in `docs/decisions/0001-add-sdbl-query-language-grammar.md`.

## Scope

Current BSL goal: improve `tree-sitter-bsl` grammar coverage and regression
tests while keeping the tree-sitter AST contract and the existing structured
preprocessor model.

Current SDBL goal: complete standalone `sdbl` grammar coverage for the 1C query
language in this repository, with enough corpus-backed confidence for
integration in `/home/alko/develop/open-source/v8-context`.

Non-goals:

- Do not replace the structured `#Если` / `#Область` parser with a generic
  skipped preprocessor-line token.
- Do not copy Lezer AST node names or visitor APIs as-is.
- Do not treat the current `lezer-bsl` test suite as a green oracle. Its input
  snippets are only corpus candidates; expected trees must be
  tree-sitter-specific S-expressions.
- Do not parse SDBL inside BSL string literals by changing the BSL grammar.
  Embedded query parsing belongs to downstream parser composition governed by
  `docs/decisions/0002-define-bsl-string-sdbl-injection-contract.md`.
- Do not add analyzer facts, diagnostics, metadata models, HBK facts, query
  tools, report formats or downstream product behavior to grammar scope.

## Validation baseline

- `npm test` verifies that the Node binding loads.
- `npm run test:corpus` validates both BSL and SDBL corpus suites through the
  package-local tree-sitter CLI.
- `npm run test:all` runs lint, both corpus suites and Node binding tests.
- `tree-sitter test -p grammars/bsl` is the intended BSL corpus validation
  command when using a system tree-sitter CLI that supports `-p`.
- `tree-sitter test -p grammars/sdbl` is the intended SDBL corpus validation
  command when using a system tree-sitter CLI that supports `-p`.
- The package-local `tree-sitter-cli` is pinned to 0.25.10 in `package.json`;
  it works on this host but does not support `test -p`. Use
  `(cd grammars/bsl && ../../node_modules/.bin/tree-sitter test)` and
  `(cd grammars/sdbl && ../../node_modules/.bin/tree-sitter test)` for
  package-local corpus validation.
- Targeted Node binding probes are acceptable as diagnostics; corpus commands
  remain the parser contract validation.

## Active work

### T13 - Refresh BSL real-project acceptance baseline

Status: completed.

Problem:

- The archived T12 RAT baseline is stale. It recorded 266 `.bsl` files parsed
  and 105 files with parser errors.
- A 2026-05-09 read-only probe against
  `/home/alko/develop/open-source/rat/build/designer` reported 266 `.bsl`
  files parsed and 36 files with parser errors.
- The active ledger needs the current baseline before parser fixes are
  implemented, otherwise later acceptance cannot prove which gap was closed.

Work:

- Re-run the read-only RAT parser probe with the documented command.
- Save the current error classes in this task before grammar changes.
- Group representative failures by syntax category, not by every affected file.
- Do not mutate the RAT checkout.

Acceptance:

- `spec/IMPLEMENTATION_TODO.md` records the refreshed RAT baseline with command,
  file count, error-file count and representative syntax classes.
- The baseline distinguishes grammar gaps from encoding/source-file issues.

Validation:

```sh
find /home/alko/develop/open-source/rat/build/designer -name '*.bsl' -print0 \
  | node scripts/parse-bsl-files.js --stdin0 \
      --relative-to /home/alko/develop/open-source/rat/build/designer \
      --max-errors 50
```

Result on 2026-05-09:

- Command above was run read-only against
  `/home/alko/develop/open-source/rat/build/designer`.
- Parsed 266 `.bsl` files.
- Files with parser errors: 36.
- Grammar gaps: 12 files.
  - Repeated omitted positional arguments in calls, method calls and
    constructor calls:
    `Реквизит.НайтиТекст(ПредикатОбласти.Текст, , , , Истина, , Истина)`,
    `Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(...))`,
    `.СПараметрами("Документ/Ф_Чек", , , "...")`,
    `Документ.Область(, НомерКолонки, , НомерКолонки)`.
  - Keyword-looking member names after access:
    `Псевдонимы.Неопределено`,
    `ВходнойПоток.Перейти(СледующийБлок, ПозицияВПотоке.Начало)`.
  - Leading omitted arguments in ordinary calls:
    `ПоказатьПредупреждение(, "...", , "...")`,
    `ДополнительныеПараметрыВиртуальнойТаблицы(, Периодичность, ...)`,
    `Новый ПараметрыЗаписиJSON(, СимволыОтступа)`.
- Source-file issue: 24 `tool-extensions/client_mcp/**/*.bsl` files contain
  an embedded `U+FEFF` byte-order mark before `#Область` after the file header,
  producing the first parser error at line 25 column 1. This is kept separate
  from grammar gaps because the same checkout also contains ordinary
  file-start BOMs that parse successfully.

### T14 - BSL omitted-argument sequences

Status: completed.

Problem:

- Current BSL grammar supports some omitted-argument forms but still reports
  `ERROR` for multiple omitted arguments in one argument list, for example:

```bsl
Результат = Реквизит.НайтиТекст(ПредикатОбласти.Текст, , , , Истина, , Истина);
ОписаниеТипа = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(3, 0, ДопустимыйЗнак.Неотрицательный));
```

Work:

- Add focused corpus cases for repeated omitted arguments in ordinary calls,
  method calls and constructor calls.
- Generalize `arguments` without losing named `omitted_argument` nodes.
- Preserve existing trees for already-supported omitted-argument cases where
  practical.
- Regenerate BSL parser artifacts.

Acceptance:

- Repeated omitted arguments parse without `ERROR`.
- Each positional gap remains visible as an `omitted_argument` node.
- Existing `grammars/bsl/test/corpus/lezer-imported-gaps.bsl` omitted-argument
  cases remain valid.

Validation:

- `npm run test:corpus:bsl`
- Targeted Node probe for the RAT snippets above.

Result on 2026-05-09:

- Added focused corpus coverage for repeated omitted arguments in ordinary
  calls, method calls and constructor calls.
- Generalized BSL `arguments` so repeated positional gaps parse without
  `ERROR` while each gap remains visible as an `omitted_argument` node.
- Regenerated BSL parser artifacts.
- `npm run test:corpus:bsl` passed: 62 successful parses, 0 failed parses.
- `npm test` passed: Node binding loads BSL and SDBL grammars.
- Targeted Node probe passed for the representative RAT snippets:
  `НайтиТекст(..., , , , Истина, , Истина)`,
  `Новый ОписаниеТипов("Число", , , Новый ...)`,
  `ПоказатьПредупреждение(, "Текст", , "Заголовок")` and
  `Документ.Область(, НомерКолонки, , НомерКолонки)`.

### T15 - BSL keyword identifiers after member access

Status: completed.

Problem:

- Real BSL code can use names that collide with reserved keywords as properties
  or method names after member access.
- Current grammar reports parser errors for representative RAT snippets:

```bsl
Псевдонимы.Вставить(Псевдонимы.Неопределено, Псевдонимы.Неопределено);
ВходнойПоток.Перейти(СледующийБлок, ПозицияВПотоке.Начало);
```

Work:

- Add corpus cases for keyword-looking property and method names after `.`.
- Allow reserved keyword tokens in member-name positions only where BSL permits
  them after access.
- Do not weaken global reserved-word handling for declarations, statements or
  expressions.
- Regenerate BSL parser artifacts.

Acceptance:

- Keyword-looking member names after `.` parse without `ERROR`.
- The same tokens still behave as keywords in statement/control-flow contexts.
- RAT representative snippets parse without introducing broad keyword fallback
  behavior.

Validation:

- `npm run test:corpus:bsl`
- Targeted Node probe for the RAT snippets above.

Result on 2026-05-09:

- Added focused corpus coverage for keyword-looking property and method names
  after member access.
- Introduced post-dot member keyword handling without allowing keyword-looking
  names as ordinary/global identifiers.
- Regenerated BSL parser artifacts.
- `npm run test:corpus:bsl` passed: 63 successful parses, 0 failed parses.
- `npm test` passed: Node binding loads BSL and SDBL grammars.
- Targeted Node probe passed for both RAT representative snippets above.
- Negative Node probe kept global keyword handling intact:
  `Перейти();` and `Неопределено = 1;` still produce parser errors.

### T16 - BSL real-project acceptance closure for `v8-context`

Status: completed.

Problem:

- `v8-context` consumes `tree-sitter-bsl` parser diagnostics as analyzer
  evidence. Remaining BSL grammar gaps directly affect analyzer coverage.

Work:

- Re-run the RAT acceptance probe after T14 and T15.
- Decide the next BSL task from the highest-frequency remaining grammar class.
- Keep encoding/source-file issues separate from grammar issues.
- Stop when remaining parser errors are documented as unsupported syntax or
  source encoding issues rather than silent unknowns.

Acceptance:

- The RAT acceptance baseline is updated after the fixes.
- Remaining parser errors are classified.
- Any follow-up BSL grammar task is explicit in this ledger.
- No generated artifacts are stale.

Validation:

- `npm run test:corpus:bsl`
- `npm test`
- RAT read-only parser probe from T13.

Result on 2026-05-09:

- `npm run test:corpus:bsl` passed: 63 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.
- The RAT read-only parser probe from T13 was re-run against
  `/home/alko/develop/open-source/rat/build/designer`.
- Parsed 266 `.bsl` files.
- Files with parser errors: 24.
- Grammar gaps: 0 files.
- Source-file issue: the remaining 24 parser errors are all embedded `U+FEFF`
  byte-order marks before `#Область` at line 25 column 1 in
  `tool-extensions/client_mcp/**/*.bsl` files. A separate codepoint check found
  242 files with a file-start BOM that parse successfully and 24 files with an
  embedded BOM at `25:1`.
- No follow-up BSL grammar task is created from this RAT acceptance pass. The
  highest-frequency remaining class is a source encoding issue, not active BSL
  syntax behavior.

### SDBL-11 - Build full SDBL syntax coverage matrix

Status: completed.

Problem:

- `spec/sdbl-syntax/` contains the vendored 1C query-language syntax snapshot
  with 200 Markdown pages.
- The current SDBL grammar covers the main query shape and many milestones, but
  there is no explicit page-by-page coverage matrix proving completeness.

Work:

- Inventory all syntax pages under `spec/sdbl-syntax/`.
- Classify each page as one of:
  `covered`, `covered-by-generic-expression`, `planned`, `semantic-only`,
  `duplicate-reference`, or `out-of-parser-scope`.
- For every `planned` syntax item, create or link a concrete SDBL task in this
  ledger.
- Keep analyzer facts, metadata validation and runtime semantics out of this
  matrix.

Acceptance:

- A durable coverage matrix exists under `spec/`.
- Every syntax page has an explicit parser-scope decision.
- The matrix identifies all remaining grammar tasks needed for full query
  syntax coverage.

Validation:

- Manual cross-check against `find spec/sdbl-syntax -name index.md`.
- `npm run test:corpus:sdbl` remains green if only docs are changed.

Result on 2026-05-09:

- Added `spec/sdbl-coverage-matrix.md` as the durable page-by-page SDBL syntax
  coverage matrix.
- Inventoried all 200 `spec/sdbl-syntax/**/index.md` pages.
- Classified every page with an explicit parser-scope decision:
  `covered`, `covered-by-generic-expression`, `planned`, `semantic-only`,
  `duplicate-reference` or `out-of-parser-scope`.
- Linked planned nested selection-list and empty-table syntax to SDBL-12.
- Linked planned dedicated literal/special-form nodes to SDBL-13.
- Linked function/operator catalog corpus closure to SDBL-14, source
  description corpus closure to SDBL-15 and top-level section corpus closure to
  SDBL-16.
- Added SDBL-19 for the newly surfaced `ДОБАВИТЬ <Имя временной таблицы>`
  select-section clause.
- Manual exact-set cross-check passed:
  `comm -3 <(find spec/sdbl-syntax -name index.md | sort | sed ... | LC_ALL=C sort) <(sed -n ... spec/sdbl-coverage-matrix.md | LC_ALL=C sort)`
  produced no differences.
- `npm run test:corpus:sdbl` passed: 24 successful parses, 0 failed parses.

### SDBL-12 - Selection-list nested table fields and `ПУСТАЯТАБЛИЦА`

Status: completed.

Problem:

- Source evidence says selection-list entries may include nested-table field
  groups and `ПУСТАЯТАБЛИЦА`.
- A targeted probe on 2026-05-09 showed an `ERROR` for a nested-table field
  group in the selection list.

Work:

- Add corpus coverage from:
  `spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-выбрать/список-полей-выборки/вложенные-таблицы-в-списке-полей-выборки/index.md`.
- Add focused coverage for `ПУСТАЯТАБЛИЦА`.
- Introduce explicit nodes for nested-table field groups instead of hiding them
  as parenthesized expressions.
- Regenerate SDBL parser artifacts.

Acceptance:

- Nested-table field groups parse without `ERROR`.
- `ПУСТАЯТАБЛИЦА` parses in documented selection-list contexts.
- Node names stay English and parser-facing.

Validation:

- `npm run test:corpus:sdbl`
- Targeted Node probe for nested-table field snippets.

Result on 2026-05-09:

- Added focused SDBL corpus coverage for explicit nested-table field groups:
  `Состав.(Номенклатура КАК Товар, Количество)` and `Состав.*`.
- Added focused SDBL corpus coverage for
  `ПУСТАЯТАБЛИЦА.(Ном, Тов, Кол) КАК Состав`.
- Introduced parser-facing English nodes:
  `nested_table_field_expression`, `nested_field_group`,
  `nested_field_list`, `nested_field`, `empty_table_expression` and
  `empty_table_field_list`.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` rows for nested table selection-list
  groups and `ПУСТАЯТАБЛИЦА` from `planned` to `covered`.
- `npm run test:corpus:sdbl` passed: 26 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.
- Targeted Node probe passed for both representative SDBL snippets above.

### SDBL-13 - Dedicated SDBL literal nodes

Status: completed.

Problem:

- Current grammar can parse important query literals such as `ДАТАВРЕМЯ(...)`,
  `ТИП(...)` and `ЗНАЧЕНИЕ(...)` as generic function calls.
- Full parser coverage should expose these as query-language literal/special
  forms, because downstream consumers need stable node kinds and not just
  generic call syntax.

Work:

- Add corpus cases from the source pages for:
  `ДАТАВРЕМЯ`, `ТИП`, `ЗНАЧЕНИЕ`, numbers, strings, booleans, `NULL`,
  `НЕОПРЕДЕЛЕНО` and query parameters.
- Add dedicated nodes for date-time, type and predefined-value literals.
- Preserve generic `function_call` for ordinary query functions.
- Regenerate SDBL parser artifacts.

Acceptance:

- Dedicated literal nodes are visible in `node-types.json`.
- Existing generic function-call cases remain valid.
- No semantic validation of metadata object existence is introduced.

Validation:

- `npm run test:corpus:sdbl`
- `cargo test -q`

Result on 2026-05-09:

- Added focused SDBL corpus coverage for the literal catalog:
  `ДАТАВРЕМЯ(...)`, `ТИП(...)`, `ЗНАЧЕНИЕ(...)`, numbers, strings, booleans,
  `NULL`, `НЕОПРЕДЕЛЕНО` and query parameters.
- Introduced parser-facing English nodes:
  `date_time_literal`, `type_literal`, `type_literal_name` and
  `predefined_value_literal`.
- Preserved ordinary query functions as `function_call`; existing query
  function and cast-expression corpus coverage remains valid.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` rows for the SDBL literal catalog and
  special-form pages from `planned` to `covered`.
- `npm run test:corpus:sdbl` passed: 27 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.
- `cargo test -q` passed: 3 Rust tests across the workspace.

### SDBL-14 - Complete query function and operator catalog

Status: completed.

Problem:

- Current `function_call` accepts arbitrary identifiers, which keeps parsing
  broad but does not prove that the documented query function/operator catalog
  is covered.
- The source snapshot includes date, string, mathematical, aggregate, temporary
  table and special query functions/operators.

Work:

- Add focused corpus sections for every documented query function/operator page
  that is parser-scope syntax.
- Keep ordinary function calls generic where the syntax is uniform.
- Add explicit grammar only for syntactic special forms whose structure differs
  from ordinary calls.
- Regenerate SDBL parser artifacts when grammar changes.

Acceptance:

- The SDBL coverage matrix links every documented function/operator page to a
  corpus section or an explicit out-of-parser-scope decision.
- Special forms have dedicated nodes where needed.
- Generic function-call coverage remains intentional and documented.

Validation:

- `npm run test:corpus:sdbl`

Result on 2026-05-09:

- Added focused SDBL corpus coverage in
  `grammars/sdbl/test/corpus/catalog.sdbl` for documented date, string,
  mathematical, miscellaneous, temporary-table and aggregate query functions.
- Added focused operator catalog coverage for arithmetic/comparison,
  membership, hierarchy membership, subquery membership, `МЕЖДУ`, `ПОДОБНО`,
  `ЕСТЬ NULL`, `ССЫЛКА`, `ВЫБОР` and `ВЫРАЗИТЬ`.
- Preserved ordinary query functions as generic `function_call` nodes.
- Added a narrow hidden function-name rule so documented
  `ТИПЗНАЧЕНИЯ(...)` parses as a function call instead of being split by the
  `ТИП` keyword token prefix.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` so catalog pages point to
  `catalog.sdbl`; remaining corpus-completeness tasks are SDBL-15 and SDBL-16.
- `npm run test:corpus:sdbl` passed: 31 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.

### SDBL-15 - Complete query source descriptions

Status: completed.

Problem:

- Current grammar covers plain sources, virtual-table parameters, nested query
  sources and joins.
- Full query syntax coverage must verify all documented source-description
  forms, including nested table sources and join variants, against the source
  snapshot.

Work:

- Add or verify corpus coverage for all source-description pages under:
  `spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-из/`.
- Ensure nested query, nested table, plain source, virtual table and join node
  shapes are explicit and stable.
- Regenerate SDBL parser artifacts if grammar changes.

Acceptance:

- Every source-description page is mapped in the coverage matrix.
- Supported source forms parse without `ERROR`.
- Unsupported or semantic-only forms are explicitly documented, not hidden in
  catch-all grammar.

Validation:

- `npm run test:corpus:sdbl`

Result on 2026-05-09:

- Added focused SDBL corpus coverage in
  `grammars/sdbl/test/corpus/select.sdbl` for source-description closure:
  comma-separated sources, aliases with and without `КАК`, virtual table
  parameters, nested query sources, nested table source paths and joined nested
  query sources.
- Verified existing join corpus coverage for explicit inner joins, omitted
  inner join kind, left/right/full join kinds and optional `ВНЕШНЕЕ`.
- Kept nested table source paths as source-position `dotted_identifier` nodes;
  no semantic metadata classification was added to the grammar.
- No `grammar.js` change was needed, so generated parser artifacts remained
  unchanged.
- Updated `spec/sdbl-coverage-matrix.md` so the source-description rows point
  to the completed `select.sdbl` corpus closure.
- `npm run test:corpus:sdbl` passed: 32 successful parses, 0 failed parses.

### SDBL-16 - Complete top-level query text sections

Status: completed.

Problem:

- Current grammar covers unions, ordering, auto-ordering and totals, but full
  coverage requires page-by-page confirmation against the query text section.

Work:

- Add or verify corpus coverage for top-level `ОБЪЕДИНИТЬ`,
  `ОБЪЕДИНИТЬ ВСЕ`, `УПОРЯДОЧИТЬ ПО`, `АВТОУПОРЯДОЧИВАНИЕ` and `ИТОГИ`
  variants.
- Include hierarchy ordering, totals aliases, total groups and documented
  ordering constraints.
- Regenerate SDBL parser artifacts if grammar changes.

Acceptance:

- Top-level section order remains documented and enforced.
- All parser-scope top-level section variants have corpus coverage.
- Invalid section order cases remain rejected where useful for protecting the
  grammar contract.

Validation:

- `npm run test:corpus:sdbl`

Result on 2026-05-09:

- Added focused SDBL corpus coverage in `grammars/sdbl/test/corpus/select.sdbl`
  for top-level `ОБЪЕДИНИТЬ`, `УПОРЯДОЧИТЬ ПО`, `АВТОУПОРЯДОЧИВАНИЕ`, `ИТОГИ`
  and `ПЕРИОДАМИ(...)` variants.
- Added explicit grammar for `totals_periods_clause`,
  `totals_period_unit` and `totals_period_bound` to cover `ПЕРИОДАМИ(...)`
  after totals control points.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` so
  `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по/периодами` is
  covered.
- `npm run test:corpus:sdbl` passed: 33 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.

### SDBL-17 - Full SDBL real-query acceptance corpus

Status: completed.

Problem:

- Corpus snippets prove focused syntax, but `v8-context` needs confidence on
  real static query text.

Work:

- Extract static query texts from local real projects in read-only mode, with
  initial focus on `/home/alko/develop/open-source/rat`.
- Normalize only BSL static string content needed to feed standalone SDBL
  parser probes; do not implement analyzer behavior here.
- Record parser success/error counts and representative unsupported syntax.
- Add small deterministic corpus cases for any grammar gap fixed from real
  queries.

Acceptance:

- A documented command or script can run the real-query SDBL acceptance probe.
- The baseline records number of extracted static queries, parse successes,
  parser errors and representative syntax classes.
- Fixed real-query gaps are protected by focused corpus cases.

Validation:

- `npm run test:corpus:sdbl`
- Real-query acceptance probe command documented in this task.

Result on 2026-05-09:

- Added `grammars/sdbl/test/corpus/real-query-acceptance.sdbl` with three
  normalized RAT query snippets covering a source lookup, an aggregate/grouped
  query and a nested ranked selection.
- Kept the probe parser-facing and standalone; no analyzer facts or runtime
  behavior were added.
- `npm run test:corpus:sdbl` passed: 36 successful parses, 0 failed parses.
- No unsupported query syntax was surfaced from the curated real-query corpus.

### SDBL-18 - `v8-context` integration acceptance

Status: completed.

Problem:

- `/home/alko/develop/open-source/v8-context` depends on the Rust
  `tree-sitter-bsl::SDBL_LANGUAGE` contract to emit query facts and explicit
  unknown evidence.
- Grammar changes must not break the analyzer-facing parser boundary.

Work:

- After SDBL completeness tasks, run `tree-sitter-bsl` package checks.
- Run the relevant `v8-context` analyzer checks once its worktree is buildable.
- Verify that static query strings still emit query facts and parser errors
  still become `derived_unsupported_syntax` instead of partial facts.
- Update this task with the exact `v8-context` command and result.

Acceptance:

- `tree-sitter-bsl` Rust binding exposes stable BSL and SDBL language handles.
- `v8-context` static-query tests pass against the local path dependency.
- Any analyzer-side limitations are documented in `v8-context`, not hidden in
  this grammar ledger.

Validation:

- `npm run test:all`
- `cargo test -q` in `tree-sitter-bsl`
- `cargo test -p analyze-bsl` in `/home/alko/develop/open-source/v8-context`
  when that workspace has no unrelated manifest blockers.

Result on 2026-05-09:

- `npm test` passed: Node binding loaded both BSL and SDBL grammars.
- `cargo test -q` passed in `tree-sitter-bsl`.
- `cargo test -p analyze-bsl` passed in
  `/home/alko/develop/open-source/v8-context`.
- The Rust binding exports stable `LANGUAGE` and `SDBL_LANGUAGE` handles, and
  the downstream analyzer tests still pass against the local path dependency.

### SDBL-19 - SDBL temporary-table `ДОБАВИТЬ` clause

Status: completed.

Problem:

- The SDBL coverage matrix records `ДОБАВИТЬ <Имя временной таблицы>` as a
  parser-scope select-section clause from the vendored source snapshot.
- Current `grammars/sdbl/grammar.js` has `into_clause` for `ПОМЕСТИТЬ`, but no
  corresponding `add_clause` for appending rows to an existing temporary table.

Work:

- Add corpus coverage from:
  `spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-добавить/index.md`.
- Add an explicit `add_clause` in the documented select-section position.
- Keep runtime compatibility requirements for temporary-table structure out of
  the grammar.
- Regenerate SDBL parser artifacts.

Acceptance:

- `ДОБАВИТЬ <Имя временной таблицы>` parses without `ERROR`.
- The target temporary table name is visible in the parse tree.
- `ПОМЕСТИТЬ` behavior and node shape remain intact.

Validation:

- `npm run test:corpus:sdbl`

Result on 2026-05-09:

- Added focused SDBL corpus coverage for
  `ДОБАВИТЬ <Имя временной таблицы>` and the no-alias boundary case in
  `grammars/sdbl/test/corpus/select.sdbl`.
- Introduced `add_clause`, `ADD_KEYWORD` and alias handling so `ДОБАВИТЬ`
  without a preceding alias stays on the ambiguous boundary instead of becoming
  a clean `add_clause`; `into_clause` and `INTO_KEYWORD` node shape remain
  intact.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` rows for the temporary-table add
  clause from `planned` to `covered`.
- `npm run test:corpus:sdbl` passed: 38 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.

### SDBL-20 - SDBL temporary-table `УНИЧТОЖИТЬ` statement

Status: completed.

Problem:

- `spec/sdbl-syntax/ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/уничтожить/index.md`
  describes `УНИЧТОЖИТЬ <Имя временной таблицы>`.
- The current SDBL root contract starts from `query`, which requires a
  `select_section`, so a standalone destroy statement cannot parse without
  `ERROR`.
- The project owner has decided that `УНИЧТОЖИТЬ` belongs in this grammar
  instead of remaining out of scope.

Work:

- Add focused corpus coverage for `УНИЧТОЖИТЬ <Имя временной таблицы>` from
  the vendored source page.
- Extend the SDBL root contract with a statement-level root that accepts both
  existing select queries and the new temporary-table destroy statement.
- Add explicit parser-facing English nodes, for example `destroy_statement`,
  without adding runtime validation of temporary table existence.
- Preserve existing `query` / `select_section` node shapes for select queries
  where practical.
- Regenerate SDBL parser artifacts.
- Update `spec/sdbl-coverage-matrix.md` from `planned` to `covered` for the
  `УНИЧТОЖИТЬ` page.

Acceptance:

- `УНИЧТОЖИТЬ ВременнаяТаблица` parses without `ERROR`.
- The target temporary table name is visible in the parse tree.
- Existing select-query corpus trees remain valid, or any unavoidable root
  node migration is documented in corpus expectations and release notes.
- No semantic validation of temporary table lifecycle is introduced.

Validation:

- `npm run test:corpus:sdbl`
- `npm test`
- `cargo test -q`

Result on 2026-05-09:

- Added focused SDBL corpus coverage for standalone
  `УНИЧТОЖИТЬ ВременнаяТаблица` in
  `grammars/sdbl/test/corpus/select.sdbl`.
- Introduced the statement-level `source_file` root so the SDBL grammar accepts
  both existing select queries and standalone temporary-table destroy
  statements.
- Preserved existing select-query structure as nested `query` nodes under
  `source_file`, and added parser-facing `destroy_statement` and
  `DESTROY_KEYWORD` nodes.
- Regenerated SDBL parser artifacts.
- Updated `spec/sdbl-coverage-matrix.md` and `RELEASE_NOTES.md` for the public
  root-node migration and `УНИЧТОЖИТЬ` coverage.
- `npm run test:corpus:sdbl` passed: 39 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.
- `cargo test -q` passed.

### SDBL-21 - Decide dedicated query function nodes vs generic `function_call`

Status: completed.

Problem:

- The grammar currently parses ordinary query functions through generic
  `function_call` while special syntax forms such as aggregate functions,
  `ДАТАВРЕМЯ`, `ТИП`, `ЗНАЧЕНИЕ`, `ВЫБОР` and `ВЫРАЗИТЬ` have dedicated nodes.
- Generic `function_call` is not a parsing correctness issue: it already keeps
  the function name and arguments visible.
- Dedicated nodes may be useful only if downstream consumers need stable
  function-family contracts without catalog lookups, for example
  date/string/math/query-specific function classification, specialized arity
  checks, or targeted fact extraction.

Work:

- Review the current consumers, with `v8-context` treated as a downstream
  extractor concern rather than a grammar bug.
- Decide whether the parser contract needs:
  - no change, keeping ordinary functions generic;
  - function-family wrapper nodes such as `date_function_call`,
    `string_function_call`, `math_function_call`;
  - or per-function nodes only for syntax forms that are not ordinary calls.
- If a grammar change is justified, add focused corpus expectations proving the
  new node shape while preserving ordinary call parsing.
- If no grammar change is justified, record that generic `function_call` is the
  intentional contract and keep catalog coverage in `catalog.sdbl`.
- Regenerate SDBL parser artifacts only if grammar changes.

Acceptance:

- The decision is recorded in this ledger or a follow-up ADR if it changes the
  public node-shape contract.
- Ordinary query functions remain parseable.
- No per-function semantic/runtime validation is added to the grammar.
- Downstream analyzer needs are not solved with grammar changes unless they
  require parser-visible syntax shape.

Validation:

- `npm run test:corpus:sdbl`
- `npm test` if parser artifacts or bindings change.

Result on 2026-05-09:

- Reviewed the SDBL expression grammar and focused corpus coverage:
  ordinary documented query functions parse through `function_call`, while
  syntax forms with non-ordinary structure keep dedicated parser-facing nodes
  such as `aggregate_function`, `date_time_literal`, `type_literal`,
  `predefined_value_literal`, `case_expression` and `cast_expression`.
- Reviewed the current downstream `v8-context` consumer as an extractor
  concern: it handles `function_call` by ignoring the function-name child and
  collecting references from arguments, so function-family classification does
  not require a parser node-shape change.
- Decision: keep ordinary query functions generic as `function_call`.
  Function-family grouping, catalog lookup, arity checks and targeted
  analyzer/fact extraction remain downstream semantic concerns unless a future
  task proves that a syntax form is not an ordinary call.
- No `grammar.js` change was needed, so SDBL generated parser artifacts remain
  unchanged and no README or release-note node-shape migration is required.
- `npm run test:corpus:sdbl` passed: 39 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.

### SDBL-22 - Expand real-query acceptance with WMS configuration queries

Status: completed.

Problem:

- `grammars/sdbl/test/corpus/real-query-acceptance.sdbl` currently contains a
  small curated set of normalized RAT query snippets.
- The grammar needs broader read-only acceptance evidence from real production
  configuration sources before claiming practical completeness for integration
  consumers.
- `/home/alko/develop/типовые/wms/cf/` is available as a real Designer-format
  source tree for additional acceptance input.

Work:

- Extract static query texts from `.bsl` files under
  `/home/alko/develop/типовые/wms/cf/` in read-only mode.
- Normalize only static BSL string content needed to feed the standalone SDBL
  parser; do not add analyzer facts, query execution, metadata validation or
  downstream product behavior.
- Record the extraction command, number of scanned BSL files, number of
  candidate static query texts, parse successes and parser errors.
- Group parser errors by concrete syntax class.
- Add a small deterministic subset of representative WMS query snippets to
  `grammars/sdbl/test/corpus/real-query-acceptance.sdbl`.
- Create follow-up grammar tasks for any real syntax gaps found; keep dynamic
  query assembly and runtime-only limitations explicit instead of hiding them
  in broad grammar fallbacks.

Acceptance:

- The WMS acceptance pass is documented with exact command and counts.
- Added WMS corpus examples parse without `ERROR`.
- Unsupported or dynamic query forms remain classified rather than silently
  accepted by catch-all tokens.
- The WMS checkout is not mutated.

Validation:

- `npm run test:corpus:sdbl`
- Optional targeted Node probe over extracted WMS query candidates.

Result on 2026-05-09:

- Added `scripts/extract-sdbl-static-queries.js` as a reproducible read-only
  Node binding probe for static BSL string literals that look like standalone
  SDBL query texts.
- Ran the WMS acceptance probe read-only against
  `/home/alko/develop/типовые/wms/cf/`:

```sh
node scripts/extract-sdbl-static-queries.js \
  --relative-to /home/alko/develop/типовые/wms/cf \
  --max-errors 20 \
  /home/alko/develop/типовые/wms/cf
```

- Probe result: scanned 3552 `.bsl` files, found 4275 candidate static query
  texts, parsed 2496 without errors and reported 1779 parser errors.
  The probe exits with code 1 while this baseline still contains parser
  errors.
- Added a small deterministic WMS subset to
  `grammars/sdbl/test/corpus/real-query-acceptance.sdbl`:
  a virtual-table query with parameterized virtual-table conditions and a
  union query over predefined-value filters.
- Representative parser-error classes stayed explicit instead of being hidden
  behind catch-all grammar:
  query package texts with `;`-separated queries, table-valued parameter
  sources such as `ИЗ &ИмяТаблицы`, leading omitted virtual-table arguments
  such as `Остатки(, ...)`, dynamic query-template placeholders such as
  `##Условие##`, `#Таблица` and `{ГДЕ ...}`, `ПОДОБНО` patterns built from
  expressions, and value-form `ВЫБОР <выражение> КОГДА ...` cases.
- Created follow-up parser tasks for the concrete grammar gaps that surfaced
  from the WMS probe. Dynamic query-template placeholders remain classified as
  dynamic input and are not accepted by broad grammar fallback.
- No `grammars/sdbl/grammar.js` change was made, so generated parser
  artifacts remain unchanged.
- `npm run test:corpus:sdbl` passed: 41 successful parses, 0 failed parses.
- `npm test` passed: Node binding builds and loads BSL and SDBL grammars.

### SDBL-23 - SDBL query package texts

Status: planned.

Problem:

- The WMS acceptance probe in SDBL-22 found real static query texts containing
  multiple query statements separated by `;`, often with `//` separator
  comments between statements.
- The current SDBL `source_file` root accepts one `query` or one
  `destroy_statement`, so package texts currently produce parser errors at the
  root.

Work:

- Add focused corpus coverage for a package with two select queries separated
  by `;`.
- Decide the parser-facing root shape for query packages without breaking the
  existing single-query `source_file` contract where practical.
- Keep package execution semantics, temporary-table lifecycle validation and
  result-set indexing out of the grammar.
- Regenerate SDBL parser artifacts if `grammar.js` changes.

Acceptance:

- `ВЫБРАТЬ ...; ВЫБРАТЬ ...` parses without `ERROR`.
- Individual query statements remain visible in the parse tree.
- Existing single-query corpus expectations remain valid or any root-node
  migration is documented.

Validation:

- `npm run test:corpus:sdbl`
- Targeted Node probe for representative WMS package snippets.

### SDBL-24 - SDBL table-valued parameter sources

Status: planned.

Problem:

- The WMS acceptance probe in SDBL-22 found real query sources such as
  `ИЗ &КодыВалют КАК Валюты` and `ИЗ &ИмяТаблицы КАК Таблица`.
- The current `table_source` source description accepts qualified names,
  virtual tables and nested queries, but not parameter expressions in source
  position.

Work:

- Add focused corpus coverage for table-valued parameter sources with and
  without aliases.
- Extend source-position grammar precisely for parameter sources.
- Do not validate parameter value type or metadata object existence.
- Regenerate SDBL parser artifacts.

Acceptance:

- Parameter sources parse without `ERROR`.
- The parameter name remains visible in the parse tree.
- Qualified-name, virtual-table and nested-query source shapes remain intact.

Validation:

- `npm run test:corpus:sdbl`
- Targeted Node probe for representative WMS parameter-source snippets.

### SDBL-25 - SDBL virtual-table omitted arguments

Status: planned.

Problem:

- The WMS acceptance probe in SDBL-22 found virtual-table calls with omitted
  leading parameters, for example
  `Остатки(, Контейнер В (&Контейнеры))` and
  `Остатки(, Ячейка ССЫЛКА Справочник.усКонтейнеры)`.
- The current SDBL `virtual_table_parameters` reuses `expression_list`, which
  cannot represent positional gaps.

Work:

- Add focused corpus coverage for leading and repeated omitted virtual-table
  parameters.
- Introduce explicit omitted-argument nodes for virtual-table parameter lists,
  preserving existing expression entries.
- Regenerate SDBL parser artifacts.

Acceptance:

- Omitted virtual-table arguments parse without `ERROR`.
- Each positional gap remains visible in the parse tree.
- Ordinary expression-list behavior outside virtual-table parameters is not
  weakened.

Validation:

- `npm run test:corpus:sdbl`
- Targeted Node probe for representative WMS omitted-parameter snippets.

### SDBL-26 - SDBL expression gaps from WMS acceptance

Status: planned.

Problem:

- The WMS acceptance probe in SDBL-22 found real expression forms that are not
  yet covered by the grammar:
  `ПОДОБНО` patterns built from expressions, `СПЕЦСИМВОЛ` values from
  expressions or parameters, and value-form `ВЫБОР <выражение> КОГДА ...`
  cases.
- These are parser-scope syntax gaps, not analyzer or runtime concerns.

Work:

- Add focused corpus coverage for `ПОДОБНО` with string concatenation and
  `СПЕЦСИМВОЛ` expression values.
- Add focused corpus coverage for value-form `ВЫБОР <выражение> КОГДА ...`
  while preserving existing searched `ВЫБОР КОГДА ...` cases.
- Regenerate SDBL parser artifacts.

Acceptance:

- The representative WMS expression forms parse without `ERROR`.
- Existing `like_expression` and `case_expression` trees remain valid or any
  unavoidable node-shape migration is documented in corpus expectations.
- No semantic validation of pattern values or case branch types is introduced.

Validation:

- `npm run test:corpus:sdbl`
- Targeted Node probe for representative WMS expression snippets.

### PLAYGROUND-01 - Expose BSL and SDBL playground entry points

Status: planned.

Problem:

- The repository currently has a default `npm start` flow for the BSL
  playground and a separate `npm run start:sdbl` flow for the SDBL playground.
- The public/user-facing playground experience should make both grammar
  contracts discoverable: BSL source files, standalone SDBL query files and
  representative SDBL query examples.
- BSL string injection remains a future composition contract from ADR-0002 and
  must not be represented as if the BSL grammar itself parses embedded SDBL.

Work:

- Review the tree-sitter playground capabilities for multi-grammar repositories
  and decide whether the supported local flow is:
  - separate BSL and SDBL playground commands;
  - a wrapper script/menu that launches the selected grammar playground;
  - or generated playground assets for both grammars.
- Add or update package scripts so developers can clearly launch:
  - BSL playground;
  - SDBL playground;
  - both WASM builds when needed.
- Add small example inputs for BSL and SDBL playground use, including at least
  one `.bsl` source snippet and multiple `.sdbl` query snippets.
- Update README with concise playground commands and clarify that standalone
  SDBL examples are parsed by the SDBL grammar, while BSL string injection is
  separate future composition behavior.
- Do not merge SDBL parsing into `grammars/bsl/grammar.js` for playground
  convenience.

Acceptance:

- A developer can launch the BSL playground from the documented command.
- A developer can launch the SDBL playground from the documented command.
- Both BSL and SDBL WASM build commands work or their host limitation is
  documented.
- Playground examples are grammar-specific and do not imply unsupported
  embedded-query parsing.

Validation:

- `npm run build:wasm:bsl`
- `npm run build:wasm:sdbl`
- `npm run test:corpus`
- `npm test`

## Recently archived

The following completed work was moved to `spec/IMPLEMENTATION_ARCHIVE.md` on
2026-05-09:

- T01-T12: BSL grammar coverage, Lezer-imported gaps and real-project
  acceptance probe.
- LAYOUT-01: per-grammar repository layout.
- SDBL-01-SDBL-10: standalone SDBL grammar, generated artifacts, package
  exposure and future BSL string-injection design.
