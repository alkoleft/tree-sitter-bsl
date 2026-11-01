# tree-sitter-bsl implementation todo

This file tracks active parser work in this repository. Completed parser-work
items are archived under `spec/archive/`.

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
- The package-local `tree-sitter-cli` is pinned to 0.27.1 in `package.json`.
  Since 0.27.x, the package-local CLI supports `test -p <dir>` from the
  repository root as well, so both forms work:
  `node_modules/.bin/tree-sitter test -p grammars/<name>` from the root and
  `(cd grammars/<name> && ../../node_modules/.bin/tree-sitter test)`.
- Targeted Node binding probes are acceptable as diagnostics; corpus commands
  remain the parser contract validation.

## Active work

No grammar changes are currently queued. Remaining follow-ups from
the 2026-11-01 corpus consolidation round (archived under
`spec/archive/IMPLEMENTATION_ARCHIVE.md`, sections `S-CORPUS-SPLIT`,
`S-REVIEW-PINS` and `S-ACCEPTANCE-FIXTURES`):

- REV-7 (resolved 2026-11-01): `npm run parse:bsl` / `npm run parse:sdbl` were
  broken: both scripts called `tree-sitter parse -p grammars/<name>`, but the
  `-p` argument was removed in newer tree-sitter CLIs and the pinned 0.25.10 CLI
  rejects it. Fixed by switching both scripts to `tree-sitter parse --scope
  source.bsl` / `--scope source.sdbl` (scopes are declared in
  `tree-sitter.json`, so no per-user config is needed); README paths and
  commands stay unchanged. Verified: both scripts parse the playground
  examples with exit code 0 on CLI 0.25.10.
- REV-8: CI and toolchain pins were bumped to tree-sitter CLI 0.27.1 on
  2026-11-02 (`package.json` devDependency `0.27.1`, CI `tree-sitter-ref:
  v0.27.1`, Rust dev-dependency `tree-sitter = "0.27.1"` with MSRV ≥ 1.90 for
  dev builds, Python optional core `tree-sitter~=0.26`; `go.mod` stays on
  `go-tree-sitter v0.25.0` = latest). The pins still have no automated check
  that they match `package.json` and current GitHub images. Action: add a lint
  step comparing `ci.yml` pins with `package.json` / `go.mod`, or accept as a
  documented manual-only contract with an owner decision recorded here.
- SKEP-302: the positive lone-trailing-comma branch of virtual-table
  parameters (`СрезПоследних(&А,)` parses as `omitted_argument`) is
  verified by a Node binding probe but not pinned by a corpus section;
  `_virtual_table_parameter_list` is load-bearing, so a refactor can break
  it silently. Action: add one pin section to `select.sdbl`.
- SKEP-304 (accepted, no work): the English-keyword hierarchy-form rejection
  (`(A, B) IN HIERARCHY (...)`) is intentionally left unpinned; the Russian
  rejection is pinned in `membership.sdbl` and the English keyword aliases
  of the new constructs are covered by at least one positive section each.
  Add the English rejection section only if English-keyword corpus coverage
  becomes a deliberate goal.
- SKEP-203/207 (blocked): the ЗУП 3.1.37.54 checkout is not available on the
  working host, so the archived "16 -> 111 clean blocks" acceptance probe
  cannot be re-run. The `Acceptance real query:` corpus sections are
  sanitized reconstructions, not extracted blocks. Re-run the probe with
  `scripts/extract-sdbl-static-queries.js` against the real checkout if it
  becomes available again.

When new work is accepted, add the next focused parser task here before
implementation and move completed history to `spec/archive/`.
