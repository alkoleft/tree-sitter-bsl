## v0.1.7

### Parser

- Added the standalone `sdbl` grammar for 1C query texts, including query
  packages, temporary-table statements, source joins, top-level sections,
  literals, functions, operators and real-query acceptance coverage.
- Expanded BSL grammar coverage for imported Lezer gaps, date literals,
  repeated omitted arguments, keyword-like member names, string literals,
  `Выполнить` chains and exception rethrow statements.
- Moved BSL and SDBL into explicit `grammars/<name>/` directories while keeping
  public binding entry points stable.

### Bindings and Editor Integration

- Exposed SDBL through Node.js, Rust, Python, Go and C bindings while keeping
  BSL as the default package language.
- Added tree-sitter highlight queries for BSL/SDBL and BSL string injections
  for static query texts.
- Added a local Zed dev extension, including `sdbl_embedded` for raw BSL string
  injection highlighting.

### Tooling and Docs

- Added per-grammar playground commands and quick parse scripts for BSL/SDBL.
- Rewrote the user-facing README in Russian and documented the current
  BSL/SDBL usage, playground, validation and editor-integration flow.
- Updated parser-work specs, ADR implementation status, release notes and the
  active/archive task ledgers.

**Full Changelog**: https://github.com/alkoleft/tree-sitter-bsl/compare/v0.1.6...v0.1.7
