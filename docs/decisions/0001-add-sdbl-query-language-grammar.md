# ADR-0001: Add an SDBL query-language grammar in this repository

Status: Accepted

Date: 2026-05-09

Decision maker: repository owner/user.

Layout note: ADR-0003 supersedes this ADR's original assumption that the BSL
grammar source and generated artifacts remain at the repository root. BSL and
SDBL now both live under `grammars/<name>/`.

## Context

`tree-sitter-bsl` currently exposes a tree-sitter grammar for 1C BSL. The
repository also needs parser support for the 1C query language described by the
vendored HBK query-language help snapshot:

`spec/sdbl-syntax/`

The query language is not BSL syntax. Its top-level text is a query description
with optional union, ordering, auto-ordering and totals sections, and the
mandatory query description starts with a `ВЫБРАТЬ` clause plus query-specific
clauses such as `ПОМЕСТИТЬ`, `ИЗ`, `ГДЕ`, `СГРУППИРОВАТЬ ПО`, `ИМЕЮЩИЕ` and
`ДЛЯ ИЗМЕНЕНИЯ`.

Some BSL string literals can contain query text, and a future parser integration
should make it possible to work with those embedded query strings. That future
integration should not force the initial query-language parser to be mixed into
the BSL grammar.

Tree-sitter supports repositories that contain multiple grammars through the
`grammars` array in `tree-sitter.json`; each grammar entry can point at a
separate parser directory via `path`.

## Decision Drivers

- Keep the future path open for parsing query text embedded in BSL strings.
- Avoid changing BSL parser behavior while the standalone query grammar is being
  introduced.
- Keep parser-facing syntax contracts in this repository instead of pushing
  query parsing into downstream analyzer code.
- Preserve small, corpus-backed grammar changes.

## Decision

Add a second grammar named `sdbl` in this repository.

The implementation keeps BSL and SDBL as separate parser contracts:

- BSL remains a separate grammar from SDBL. Its current physical layout is
  governed by ADR-0003.
- SDBL has its own grammar source, generated parser artifacts, corpus tests and
  optional queries.
- `tree-sitter.json` lists both grammar entries.
- The SDBL parser root node and public node names will describe query-language
  syntax, not downstream analyzer facts or HBK metadata facts.
- Cross-grammar BSL string injection is governed separately by ADR-0002.

The intended SDBL grammar identity is:

- grammar name: `sdbl`;
- title: `SDBL`;
- scope: `source.sdbl`;
- default file type for corpus and standalone parsing: `sdbl`;
- injection regex, when added: `^sdbl$`.

The intended layout is:

- `grammars/sdbl/grammar.js` for the SDBL source grammar;
- `grammars/sdbl/src/grammar.json`, `grammars/sdbl/src/node-types.json` and
  `grammars/sdbl/src/parser.c` for generated SDBL artifacts;
- `grammars/sdbl/test/corpus/*.sdbl` for SDBL corpus tests;
- `grammars/sdbl/queries/*` only when a concrete query use case exists.

If later implementation discovers that the tree-sitter CLI or package bindings
require a different multi-grammar layout, update this ADR and
`spec/sdbl-query-language.md` before moving generated artifacts again.

No new runtime or parser-generation dependency is accepted by this ADR. If SDBL
requires an external scanner or a new package dependency later, capture that in
a follow-up ADR or an explicit update to this ADR before implementation.

## Alternatives Considered

### Separate repository

Rejected for now. A separate repository would keep package surfaces isolated,
but the stated future direction is to work with query strings inside BSL code.
Keeping both grammars in one repository preserves one place for shared release,
corpus and injection decisions.

### Merge query syntax directly into the BSL grammar

Rejected for the first implementation phase. Query text has a distinct top-level
grammar and clause structure. Mixing it into `source_file` or generic BSL string
handling would blur parser contracts and make invalid BSL easier to accept.

### Lexical or regex-only query extraction

Rejected as a parser strategy. Lexical extraction can be a temporary downstream
consumer technique, but this repository owns grammar behavior and should model
observable query syntax with tree-sitter rules and corpus expectations.

## Consequences

- BSL behavior must remain stable while SDBL is added.
- SDBL node shapes become a durable parser-facing contract and must be protected
  by focused corpus tests.
- SDBL is exposed through explicit package and binding entry points while the
  existing BSL entry points remain the default package language.
- BSL string injection is implemented as an integration layer governed by
  ADR-0002, without changing BSL grammar behavior.
- Query-language semantics, analyzer diagnostics, platform metadata facts and
  HBK fact models remain out of scope for this grammar.
- Multi-grammar binding exposure may require compatibility work because current
  package bindings expose a single BSL language surface.

## Implementation Status

Implemented.

- `grammars/sdbl/grammar.js`, generated artifacts and corpus tests exist.
- `tree-sitter.json` registers both `bsl` and `sdbl`.
- SDBL binding/package exposure exists for Node.js, Rust, Python, Go and C.
- The active SDBL grammar contract lives in `spec/sdbl-query-language.md`.

## Historical Implementation Plan

1. Keep `spec/IMPLEMENTATION_TODO.md` as the active ledger for both BSL and SDBL
   parser work.
2. Use `spec/sdbl-query-language.md` as the durable SDBL grammar contract.
3. Use `spec/sdbl-source-evidence.md` to track source pages and evidence copied
   from the HBK query-language help snapshot.
4. Add `grammars/sdbl/grammar.js` with a minimal standalone query parser before
   changing bindings.
5. Add focused SDBL corpus files before each grammar behavior change.
6. Generate SDBL parser artifacts under the SDBL grammar directory.
7. Add a second `tree-sitter.json` grammar entry for SDBL once the generated
   layout is proven locally.
8. Add binding exports only after the standalone parser and corpus are stable.
9. Do not implement BSL string injection until a later accepted task or ADR
   defines that integration contract. ADR-0002 later defined and implemented
   that integration contract.

## Verification

- [x] BSL corpus validation remains available through `npm run test:corpus:bsl`
      or a system CLI with `tree-sitter test -p grammars/bsl`.
- [x] `npm test` verifies the Node binding surface.
- [x] `tree-sitter generate --output grammars/sdbl/src grammars/sdbl/grammar.js`
      generates SDBL artifacts
      without unresolved conflicts.
- [x] SDBL corpus validation remains available through
      `npm run test:corpus:sdbl` or a system CLI with
      `tree-sitter test -p grammars/sdbl`.
- [x] SDBL corpus tests cover every public node-shape change introduced for the
      query grammar.
- [x] No SDBL task introduces analyzer facts, diagnostics, metadata models, HBK
      facts, query tools or downstream report formats into parser grammar scope.

## References

- Local source snapshot: `spec/sdbl-syntax/`
- Snapshot origin: `/home/alko/develop/open-source/v8-context-hbk/target/help/shquery-ru/работа-с-запросами/синтаксис-текста-запросов`
- Tree-sitter CLI `tree-sitter.json` grammar configuration:
  https://tree-sitter.github.io/tree-sitter/cli/init.html
