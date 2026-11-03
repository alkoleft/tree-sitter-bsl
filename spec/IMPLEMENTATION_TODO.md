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

No grammar changes are currently queued. The completed statement-separator
contract (issue #6, commits 5e81581 + 4fa0bd4, plus the owner-requested
member-name/empty-statement follow-up below) is the latest accepted BSL
change; see the durable contract below. The completed line_comment CR fix
(issue #19, PR #20) is archived under
`spec/archive/IMPLEMENTATION_ARCHIVE.md`, section `L-2026-11-02`.

- L-2026-11-02 (issue #6, done; grammar 5e81581, corpus 4fa0bd4): BSL moved
  from a terminator model (`optional(';')` inside each statement) to a
  separator model: statements of one block level are separated by `;`, and
  `;` is REQUIRED between any two statements of the same level, including
  after the enders of compound statements (`КонецЕсли` / `КонецЦикла` /
  `КонецПопытки` etc.) when the block continues at that level. The last
  statement of a level may omit the trailing `;` (a chain of nested enders
  with no trailing statement parses without `;`, e.g.
  `Возврат 1 КонецЕсли КонецЕсли КонецЦикла`). Consequences for consumers:
  newline is NOT a separator (it is whitespace), so `А = 1 Б = 2` and
  `А = 1\nБ = 2` now produce ERROR/MISSING — code that relied on the old
  permissive parsing must add `;` between statements. Implementation shape:
  `_terminated_statement` lists all 17 statement kinds inline; the
  `statementSequence($, extra)` helper builds all 15 statement containers (source_file, region,
  preproc_if ×3, procedure, function, try body, try except branch, if,
  elseif, else, while, for, for_each); `label_statement` (`~Метка:`),
  `preprocessor` (`#Область`, `&Аннотация`) and the module-level
  `procedure_definition` / `function_definition` / `var_definition` are NOT
  statements — they are self-terminating level elements and need no `;`.
  When a new statement rule is added, add its reference to the
  `_terminated_statement` choice (single action, verified by the invariant
  `grep -c "repeat($._statement)|repeat($._definition)|repeat($._exception_statement)" == 0`).
  Recovery forms when `;` is missing depend on the boundary: adjacent
  assignments (`А = 1 Б = 2;`) recover as an `ERROR` node inside the first
  `assignment_statement` (the RHS is reinterpreted as an expression chain;
  see `semicolons.bsl` «Разделитель обязателен: два присваивания без ;»);
  a keyword-led or compound-statement boundary inserts a `MISSING ";"`
  node between the two statements (see `semicolons.bsl` «Составной
  statement требует ; при продолжении уровня», «Простой перед составным
  без ;», `control-flow.bsl` «Продолжить и Прервать без разделителя»); the
  pre-existing «Двойной незакрытый метод» recovery shape is unchanged
  (still a flat `ERROR` node, no `MISSING`).
  Pinned by `grammars/bsl/test/corpus/semicolons.bsl` and the
  updated sections in control-flow.bsl (#16 is now an ERROR pin), draft-
  coverage.bsl, misc-coverage.bsl.
- L-2026-11-02 (issue #6 follow-up, owner rulings O1+O2, done): two
  node-shape migrations landed on top of the separator contract.
  (1) `empty_statement` is a named node: `prec(-1, ';')` rule renamed from
  `_empty_statement`, all references updated (`_statement`,
  `statementSequence` repeat branch); stray/repeated semicolons
  (`;;`, `А = 1;;;`, trailing `;` after module-level `Перем` or an `ERROR`
  region) now produce `(empty_statement)` nodes in every statement
  container. (2) Keyword-like member names after `.` are lexed by a
  dedicated `member_name` token (mirrors the `identifier` regex including
  `ё`/`Ё`, unlike the original PR #6 revision; its lexical precedence
  contract — member_name loses to keywords/identifier outside the
  after-dot position — is documented on the rule in `grammar.js`) and
  aliased to plain leaves:
  `_access_property` ends in `alias($.member_name, $.property)`,
  `_access_method_call` uses `field('name', alias($.member_name,
  $.identifier))`; the old `_member_keyword` alternative list
  (`memberNameKeywords`) was removed. Trees: `Структура.Функция` →
  `(property)` leaf (was `(property (FUNCTION_KEYWORD))`);
  `Структура.Функция()` → `name: (identifier)` leaf (was
  `(identifier (FUNCTION_KEYWORD))`). Consequences:
  `identifier`/`property` lost their 39 keyword children in
  `node-types.json`; `AND_KEYWORD`/`OR_KEYWORD`/`NOT_KEYWORD` became
  unreachable node types (they only ever appeared via keyword-member
  aliases; as operators they are aliased to `operator`), so the BSL
  highlight query dropped those three dead patterns (both the
  `grammars/bsl/queries` copy and the identical Zed
  `editors/zed-bsl/languages/bsl` copy) — real `И`/`Или`/`Не` still
  highlight via `(operator) @operator`. Recovery shapes for invalid inputs
  also shifted (`Двойной незакрытый метод` flattens the member name into
  `(property)`; stray `НЕ` becomes `(ERROR (operator))`; adjacent quoted
  strings recover as `(ERROR (identifier))`) — all documented in
  RELEASE_NOTES. Pinned by corpus: access.bsl (2 sections), methods.bsl,
  semicolons.bsl (empty-statement sections), lezer-imported-gaps.bsl,
  date-literals.bsl, preprocessors.bsl, draft-coverage.bsl,
  incomplete-expressions.bsl, string-literals.bsl; full corpus green.

Durable contracts from that work that stay active:

- Corpus convention for line endings: raw `\r` / `\r\n` bytes are
  allowed only inside the input body of a section; scaffolding (headers,
  `---`, expected trees) must stay LF — a bare `\r` inside scaffolding makes
  `tree-sitter test` silently skip the section with exit 0, so after adding
  files with `\r`, check that the section counter grew. Corpus directories
  are protected from git EOL normalization by `-text` in `.gitattributes`.
  Also note the corpus input terminator convention: `tree-sitter test`
  strips exactly one trailing `\n` byte from the input body, so a section
  that must end without a line terminator needs its input line immediately
  before the `---` divider (no blank separator line).
- Known runtime limitation (no grammar fix possible): tree-sitter 0.25+
  does not treat a lone `\r` as a line terminator for point positions —
  `startPosition.row` does not advance on `\r` (CRLF does); consumers that
  need row data must normalize line endings themselves.
- Embedded grammar artifacts (`editors/zed-bsl/grammars/sdbl-embedded/src/*`)
  are derived from `grammars/sdbl/grammar.js` (single source of truth) and
  must be re-committed whenever `grammars/sdbl` regeneration changes parser
  output, or the CI repository-wide `tree-sitter generate` sweep
  (`parser-test-action` verify step) fails. Validation of the Zed extension
  path itself (`extension.toml` pins a rev to an external `file://` path)
  is still pending until that path is restored on a development host.

Remaining follow-ups from the 2026-11-01 corpus consolidation round (archived
under `spec/archive/IMPLEMENTATION_ARCHIVE.md`, sections `S-CORPUS-SPLIT`,
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
  Note: the `tree-sitter = "0.25"` Rust example in the README is the deliberate
  consumer minimum (language ABI 15), not a pin to sync with the devDependency
  bump; do not "fix" it to 0.27.
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
