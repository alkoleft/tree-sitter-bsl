## Unreleased

### Parser

- **Breaking behavioral change (issue #6)**: `bsl` statements are now
  separated, not terminated — `;` is required between ANY two statements of
  the same block level, including after the enders of compound statements
  (`КонецЕсли` / `КонецЦикла` / `КонецПопытки` / `КонецПроцедуры`) when the
  block continues at that level. The last statement of a level may still omit
  the trailing `;`, and a chain of nested enders with no trailing statement
  stays valid (`Возврат 1 КонецЕсли КонецЕсли КонецЦикла`). Since a newline
  is insignificant whitespace, not a separator, code that previously parsed
  two adjacent statements without `;` (`А = 1 Б = 2`, `А = 1\nБ = 2`) now
  produces `ERROR` / `MISSING ";"` nodes — downstream consumers that relied
  on the old permissive parsing must expect error trees on separator-less
  code. Labels (`~Метка:`), preprocessor directives and annotations
  (`#Область`, `&НаКлиенте`), and module-level `Процедура` / `Функция` /
  `Перем` definitions are self-terminating level elements and need no `;`;
  empty statements (`;;;`) remain valid. Implemented via a
  `TERMINATED_STATEMENTS` registry plus a `statementSequence` helper covering
  all 15 statement containers; 21 GLR conflicts document the separator
  boundaries.
- Recovery form for a missing separator is a `MISSING ";"` node between the
  two statements (pinned by the new `semicolons.bsl` corpus file, 15
  sections). The pre-existing recovery shape of the «Двойной незакрытый
  метод» form (doubly unclosed method call) is unchanged — still a flat
  `ERROR` node, no `MISSING` node appears there.
- Corpus inputs updated to the separator contract: `;` added only between
  non-last statements of the same level in `control-flow.bsl`,
  `draft-coverage.bsl` and `misc-coverage.bsl` (expected trees unchanged
  where no node changed); «Продолжить и Прервать без разделителя» is now an
  ERROR pin (`MISSING ";"`).
- No node-shape migration for consumers: `node-types.json` is unchanged,
  separator categories are hidden rules (`_terminated_statement`,
  `_statement`, `_empty_statement` with `prec(-1, ';')`), and the `;` itself
  produces no node — only the missing-separator recovery adds
  `MISSING ";"`.
- `line_comment` in both `bsl` and `sdbl` now stops at any line terminator
  (`\r`, `\n`, `\r\n`) instead of only `\n` (issue #19). Previously, in
  CR-only files (a legit 1C export EOL form) the first `//` comment silently
  swallowed the rest of the file — the whole module parsed as one or two
  `line_comment` nodes with `hasError = false`. Minimal node-shape change:
  in CRLF files the `line_comment` node no longer includes the trailing
  `\r` (it belongs to whitespace); node names, fields and `node-types.json`
  are unchanged. Known limitation: a lone `\r` still does not advance
  `startPosition.row` (tree-sitter runtime behavior, not fixable in the
  grammar).
- Regenerated BSL and SDBL parser artifacts with tree-sitter CLI 0.27.1
  (`parser.c` and the vendored `src/tree_sitter/array.h`); `grammar.json` and
  `node-types.json` are unchanged and the language ABI stays 15.
- The third grammar surface — the Zed `sdbl-embedded` adapter under
  `editors/zed-bsl/grammars/sdbl-embedded` — was regenerated with the same
  tree-sitter CLI 0.27.1 (`parser.c` and `src/tree_sitter/array.h` only;
  `grammar.json` and `node-types.json` unchanged), so a repository-wide
  `tree-sitter generate` sweep is now idempotent.
- Identifier charset narrowed by the 0.27.1 generator: Unicode fold variants
  of Latin letters (U+017F `ſ`, U+212A K) are no longer accepted inside
  identifiers in any of the three parsers. Cyrillic identifiers are
  unaffected and stay pinned by corpus sections.
- Node-shape migration in the incomplete-expressions corpus section
  «Двойной незакрытый метод»: the expected tree for a doubly unclosed method
  call changed from a `MISSING` recovery node to an `ERROR` root, following the
  upstream tree-sitter error-recovery change (tree-sitter PR #5766, building on
  #5469) shipped with CLI 0.27.x. Queries that matched `MISSING` nodes for this
  shape must match `ERROR` instead. This is a runtime-behavior change of
  CLI 0.27.x, not a change in the parser tables: Node-binding consumers
  running on `tree-sitter` ^0.25.x keep receiving the `MISSING`-node tree for
  this form (verified with the 0.25.1 runtime against the regenerated
  parser), so only consumers on the 0.27.x runtime observe the `ERROR` shape.

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
