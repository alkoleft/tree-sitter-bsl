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
- The package-local `tree-sitter-cli` is pinned to 0.25.10 in `package.json`;
  it works on this host but does not support `test -p`. Use
  `(cd grammars/bsl && ../../node_modules/.bin/tree-sitter test)` and
  `(cd grammars/sdbl && ../../node_modules/.bin/tree-sitter test)` for
  package-local corpus validation.
- Targeted Node binding probes are acceptable as diagnostics; corpus commands
  remain the parser contract validation.

## Active work

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
- BSL string injection is a composition contract from ADR-0002 and must not be
  represented as if the BSL grammar itself parses embedded SDBL.

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
