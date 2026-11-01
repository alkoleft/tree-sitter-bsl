## Unreleased

### Parser

- Regenerated BSL and SDBL parser artifacts with tree-sitter CLI 0.27.1
  (`parser.c` and the vendored `src/tree_sitter/array.h`); `grammar.json` and
  `node-types.json` are unchanged and the language ABI stays 15.
- Node-shape migration in the incomplete-expressions corpus section
  «Двойной незакрытый метод»: the expected tree for a doubly unclosed method
  call changed from a `MISSING` recovery node to an `ERROR` root, following the
  upstream tree-sitter error-recovery change (tree-sitter PR #5766, building on
  #5469) shipped with CLI 0.27.x. Queries that matched `MISSING` nodes for this
  shape must match `ERROR` instead.

### Bindings and Tooling

- Bumped the toolchain pins: tree-sitter CLI 0.25.10 → 0.27.1
  (`package.json` devDependency, CI `tree-sitter-ref: v0.27.1`), Rust
  dev-dependency `tree-sitter` 0.25.1 → 0.27.1 (MSRV ≥ 1.90 for dev builds),
  Node `tree-sitter` peer/dev `^0.25.0` → `^0.25.1`, Python optional core
  dependency `tree-sitter~=0.24` → `~=0.26`; `go.mod` stays on
  `go-tree-sitter v0.25.0` (latest).

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
