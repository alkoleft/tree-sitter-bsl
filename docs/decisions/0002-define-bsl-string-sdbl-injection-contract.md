# ADR-0002: Define BSL string injection contract for SDBL

Status: Accepted

Date: 2026-05-09

Decision maker: repository owner/user.

## Context

ADR-0001 added a standalone `sdbl` grammar in this repository and explicitly
deferred parsing query text embedded in BSL string literals. The standalone SDBL
parser is now exposed through package bindings, but BSL still parses query text
as ordinary string syntax.

The current BSL grammar represents static string values as `string` nodes with
`string_content` children. Multiline BSL strings are parsed through
`multiline_string` and aliased to the same public `string` node shape. The SDBL
grammar has a separate `query` root and `source.sdbl` scope.

Embedded query support needs a clear parser-facing contract before any
implementation changes. Without that contract, a future change could either
merge query syntax into the BSL grammar or over-detect arbitrary string
literals, both of which would weaken the current parser boundary.

## Decision Drivers

- Preserve the existing BSL AST shape for string literals.
- Keep BSL and SDBL grammar behavior separate.
- Make embedded-query parsing available for static query strings without adding
  analyzer facts, metadata models or downstream product behavior.
- Avoid false positives from ordinary strings that happen to contain query-like
  words.
- Keep dynamic string construction explicit as unsupported until a later
  accepted task broadens the contract.

## Decision

Future embedded-query support will use a parser composition layer based on
tree-sitter injections. It will not merge SDBL syntax into `grammar.js`.

The initial implementation target is a repository-owned injection query for the
BSL grammar:

- planned file: `queries/injections.scm`;
- injected language: `sdbl`;
- injected scope: `source.sdbl`;
- injected parser root: the existing SDBL `query` root;
- BSL host nodes: existing `string` nodes and their `string_content`
  descendants.

Detection is based on static BSL string syntax, not semantic knowledge of 1C
objects:

1. A candidate must be a single statically recoverable BSL `string` node.
2. The candidate content is the BSL string literal text after BSL string
   normalization: string delimiters are excluded, doubled quotes are treated as
   literal quotes, and multiline continuation content is combined in source
   order.
3. After leading whitespace, the normalized content must begin with an SDBL
   query start keyword accepted by the SDBL grammar: `ВЫБРАТЬ` or `SELECT`,
   case-insensitively.
4. The SDBL parser must parse the normalized content without requiring any BSL
   AST shape change.

Recognized BSL carrier contexts, such as assigning a string to `Запрос.Текст`
or passing a string to `Новый Запрос(...)`, may be added later as additional
precision filters. They are not required for the first injection contract, and
they must not require symbol resolution or platform metadata.

## Alternatives Considered

### Merge SDBL syntax into the BSL grammar

Rejected. Query text is not BSL source syntax; it is data carried by string
literals. Merging the grammars would change the BSL parser contract and make it
easier to accept invalid BSL just to expose query subtrees.

### Downstream-only query extraction

Rejected as the primary repository contract. Downstream tools may still compose
BSL and SDBL parsing themselves, but this repository owns parser-facing grammar
contracts and should provide the standard injection metadata when the behavior
is implemented.

### Carrier-name-only detection

Rejected. A string assigned to a variable named like `ТекстЗапроса` is not
enough evidence by itself. The normalized string content must start with an SDBL
query keyword before injection is applied.

## Consequences

- BSL corpus expectations and generated BSL node types remain unchanged when
  this decision is implemented.
- SDBL grammar coverage remains protected by `grammars/sdbl/test/corpus/*.sdbl`;
  embedded-query tests should verify composition behavior, not new SDBL syntax.
- Injection implementation must prove that BSL string delimiters and multiline
  continuation markers are not parsed as SDBL query text.
- Dynamic query construction remains unsupported by this repository's injection
  contract unless a later ADR or ledger task expands it.
- Editors or clients that do not support tree-sitter injections still retain the
  standalone BSL and SDBL parser APIs.

## Unsupported in the Initial Injection Contract

- Query text built through string concatenation.
- Query text built through variables, parameters, `СтрШаблон` or other runtime
  calls.
- Adjacent BSL string literals treated as one query.
- Partial query fragments that do not start with `ВЫБРАТЬ` or `SELECT` after
  leading whitespace.
- Semantic validation of source names, fields, parameters or metadata.

## Implementation Plan

1. Keep `grammar.js` and BSL generated artifacts unchanged.
2. Add focused BSL host corpus or query tests that cover:
   - a single-line string beginning with `ВЫБРАТЬ`;
   - a multiline string beginning with `ВЫБРАТЬ`;
   - an ordinary non-query string that must not inject SDBL;
   - a dynamically concatenated query fragment that must remain unsupported.
3. Add `queries/injections.scm` only after the local validation proves that the
   captured injection content excludes BSL quotes and multiline continuation
   markers.
4. Use `sdbl` as the injected language and preserve the existing SDBL parser
   root and node shapes.
5. If tree-sitter injection queries cannot express the normalized static-string
   detector in a host-agnostic way, stop and update this ADR before adding a
   package helper, fallback extractor or downstream adapter.

## Verification

- [ ] `tree-sitter test` still validates the BSL corpus from the repository
      root.
- [ ] `tree-sitter test -p grammars/sdbl` still validates the SDBL corpus.
- [ ] `npm test` still verifies binding loading for BSL and SDBL.
- [ ] Injection tests prove that accepted static BSL query strings parse as
      `source.sdbl`.
- [ ] Injection tests prove that ordinary strings and dynamic fragments are not
      injected.
- [ ] No implementation changes `grammar.js`, BSL generated artifacts or public
      BSL node shapes for injection support.

## References

- ADR-0001: `docs/decisions/0001-add-sdbl-query-language-grammar.md`
- SDBL grammar contract: `spec/sdbl-query-language.md`
- SDBL source evidence: `spec/sdbl-source-evidence.md`
- BSL string corpus: `test/corpus/string-literals.bsl`
