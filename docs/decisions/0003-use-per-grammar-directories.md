# ADR-0003: Use per-grammar directories for BSL and SDBL

Status: Accepted

Date: 2026-05-09

Decision maker: repository owner/user.

## Context

ADR-0001 introduced a second grammar, `sdbl`, under `grammars/sdbl/` while the
existing BSL grammar remained at the repository root. After SDBL binding
exposure, the repository now has two first-class parser contracts but only one
of them uses an explicit grammar directory.

Keeping BSL at the root makes build and validation paths asymmetric:
`grammar.js`, `src/` and `test/corpus/` refer to BSL implicitly, while SDBL is
addressed explicitly through `grammars/sdbl/`. Future parser work is easier for
agents and maintainers if every grammar has the same local shape.

## Decision Drivers

- Make BSL and SDBL parser ownership explicit in the filesystem.
- Keep public binding names and parser symbols stable.
- Avoid mixing generated artifacts for different grammars.
- Preserve focused per-grammar corpus validation.

## Decision

Store each grammar under `grammars/<name>/`.

The BSL grammar layout is:

- `grammars/bsl/grammar.js` for the BSL source grammar;
- `grammars/bsl/src/grammar.json`, `grammars/bsl/src/node-types.json` and
  `grammars/bsl/src/parser.c` for generated BSL artifacts;
- `grammars/bsl/test/corpus/*.bsl` for BSL corpus tests;
- `grammars/bsl/queries/*` for BSL tree-sitter queries, including highlights
  and SDBL injections.

The SDBL grammar remains under `grammars/sdbl/` with the same local shape.

Public package and binding surfaces keep their existing names:

- C symbols remain `tree_sitter_bsl()` and `tree_sitter_sdbl()`;
- the default Node, Rust, Python and Go entry points remain BSL;
- SDBL-specific entry points remain explicit.

This ADR supersedes only the physical BSL layout assumptions in ADR-0001 and
ADR-0002. It does not change BSL or SDBL grammar behavior, node shapes or the
BSL string injection contract.

## Alternatives Considered

### Keep BSL at the repository root

Rejected. This preserves the historical tree-sitter package layout, but it
keeps BSL implicit while SDBL is explicit. That asymmetry makes multi-grammar
maintenance and generated-artifact review harder.

### Move only generated BSL artifacts

Rejected. Splitting `grammar.js`, generated artifacts and corpus files across
root and `grammars/bsl/` would create a new non-standard layout and make
validation commands less obvious.

## Consequences

- Build metadata must reference `grammars/bsl/src` instead of `src`.
- Package manifests must include `grammars/bsl/**` instead of root BSL files.
- BSL corpus validation should run with `tree-sitter test -p grammars/bsl`.
- Historical references to root BSL paths in active specs and agent rules must
  be updated to the per-grammar layout.

## Implementation Status

Implemented.

- BSL and SDBL source grammars, generated artifacts, corpus tests and query
  files live under `grammars/<name>/`.
- `tree-sitter.json` uses explicit `path` entries for both grammars.
- Build metadata and bindings reference `grammars/bsl/src` and
  `grammars/sdbl/src`.
- Active specs and agent rules point future grammar work at the per-grammar
  layout.

## Historical Implementation Plan

1. Move BSL source grammar, generated artifacts and corpus files into
   `grammars/bsl/`.
2. Add `path: "grammars/bsl"` to the BSL entry in `tree-sitter.json`.
3. Update Node, Rust, Python, Go, CMake, Make and package metadata paths.
4. Update active documentation and agent rules so future parser work starts
   from `grammars/bsl/` or `grammars/sdbl/` explicitly.
5. Validate both per-grammar corpus suites and the binding load tests.

## Verification

- [x] BSL corpus validation remains available through `npm run test:corpus:bsl`
      or a system CLI with `tree-sitter test -p grammars/bsl`.
- [x] SDBL corpus validation remains available through
      `npm run test:corpus:sdbl` or a system CLI with
      `tree-sitter test -p grammars/sdbl`.
- [x] `npm test` verifies that Node binding loading still works for BSL and
      SDBL.
- [x] No generated parser symbol or public binding entry point is renamed.
- [x] Active specs and agent rules no longer point future BSL work at root
      `grammar.js`, `src/` or `test/corpus/`.

## References

- ADR-0001: `docs/decisions/0001-add-sdbl-query-language-grammar.md`
- ADR-0002: `docs/decisions/0002-define-bsl-string-sdbl-injection-contract.md`
