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

Status: planned.

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

### SDBL-12 - Selection-list nested table fields and `ПУСТАЯТАБЛИЦА`

Status: planned.

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

### SDBL-13 - Dedicated SDBL literal nodes

Status: planned.

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

### SDBL-14 - Complete query function and operator catalog

Status: planned.

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

### SDBL-15 - Complete query source descriptions

Status: planned.

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

### SDBL-16 - Complete top-level query text sections

Status: planned.

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

### SDBL-17 - Full SDBL real-query acceptance corpus

Status: planned.

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

### SDBL-18 - `v8-context` integration acceptance

Status: planned.

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

## Recently archived

The following completed work was moved to `spec/IMPLEMENTATION_ARCHIVE.md` on
2026-05-09:

- T01-T12: BSL grammar coverage, Lezer-imported gaps and real-project
  acceptance probe.
- LAYOUT-01: per-grammar repository layout.
- SDBL-01-SDBL-10: standalone SDBL grammar, generated artifacts, package
  exposure and future BSL string-injection design.
