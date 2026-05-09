## What's Changed

### Unreleased
- SDBL: fixed expression-valued `ПОДОБНО ... СПЕЦСИМВОЛ ...` and
  value-form `ВЫБОР <expression> КОГДА ...` parsing; `like_expression`
  pattern/escape fields now expose `query_expression`, and `case_expression`
  can expose an optional `value` field.
- BSL/SDBL: added tree-sitter highlight queries and BSL string injections for
  static query texts, plus local Zed SDBL highlighting support.
- Zed: added an `sdbl_embedded` grammar for raw BSL string injection so editor
  highlighting parses the actual injected carrier text without weakening
  standalone SDBL grammar behavior.
- SDBL: fixed virtual-table parameter lists with omitted positional arguments
  such as `Остатки(, Контейнер В (&Контейнеры))`, exposing each gap as
  `omitted_argument`.
- SDBL: fixed `ИНДЕКСИРОВАТЬ ПО` parsing after `ГДЕ`/filter clauses, matching
  real package queries from WMS static query strings.
- SDBL/Zed: highlighted full query parameters such as `&Контейнеры`, including
  both the `&` marker and parameter name.
- SDBL/Zed: highlighted query function names such as `ЕСТЬNULL` as built-in
  functions so generic identifier highlighting does not hide them.
- SDBL: added `query_package` for semicolon-separated query texts while keeping
  single-query `source_file -> query` trees intact.
- SDBL: changed the grammar root to `source_file`, preserving select queries as
  nested `query` nodes and adding standalone `destroy_statement` for
  `УНИЧТОЖИТЬ <Имя временной таблицы>`.

### Features
- Added Go, Python, Java, and Kotlin bindings (#5)

### Fixes
- Python: compatibility with `tree-sitter >= 0.25` — use `Parser(language)` constructor, return `PyCapsule`, wrap language capsule in `tree_sitter.Language`
- Kotlin: bump `jvmToolchain` to 22 for `jtreesitter` FFM compatibility
- Java/Kotlin: separate main and test sources into standard Gradle layout; add CMake native build integration
- CI: pin `node-version` to 22 to fix build on Node 24
- Updated `tree-sitter` to `^0.25.0` for compatibility with `tree-sitter-cli` 0.26.x

### CI
- Added PyPI and crates.io publishing
- Added `test-python`, `test-go` jobs; extended paths filter in lint
- Regenerated parser with `tree-sitter` v0.26.6

**Full Changelog**: https://github.com/alkoleft/tree-sitter-bsl/compare/v0.1.5...v0.1.6
