## Unreleased

### Parser

- **Breaking behavioral change (issue #6)**: `bsl` statements are now
  separated, not terminated — `;` is required between ANY two statements of
  the same block level, including after the enders of compound statements
  (`КонецЕсли` / `КонецЦикла` / `КонецПопытки`) when the
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
  empty statements (`;;;`) remain valid. Implemented via the
  `_terminated_statement` category plus a `statementSequence` helper covering
  all 15 statement containers; 21 GLR conflicts document the separator
  boundaries.
- Recovery forms for a missing separator depend on what the second statement
  starts with. When the next token can extend the first statement — adjacent
  assignments (`А = 1 Б = 2;`) — the right-hand side is reinterpreted as an
  expression chain and an `ERROR` node appears inside the first
  `assignment_statement`; no `;` is inserted (see `semicolons.bsl`
  «Разделитель обязателен: два присваивания без ;»). When the second
  statement starts with a token that cannot continue the first — a
  keyword-led statement or the end of a compound statement followed by
  another statement — a `MISSING ";"` node is inserted between the two
  statements (see `semicolons.bsl` «Составной statement требует ; при
  продолжении уровня», «Простой перед составным без ;», and
  `control-flow.bsl` «Продолжить и Прервать без разделителя»). The
  pre-existing recovery shape of the «Двойной незакрытый метод» form (doubly
  unclosed method call) is unchanged — still a flat `ERROR` node, no
  `MISSING` node appears there.
- Corpus inputs updated to the separator contract: `;` added only between
  non-last statements of the same level in `control-flow.bsl`,
  `draft-coverage.bsl` and `misc-coverage.bsl` (expected trees unchanged
  where no node changed); «Продолжить и Прервать без разделителя» is now an
  ERROR pin (`MISSING ";"`).
- **Node-shape migration for consumers** (changes `node-types.json`):
  - `empty_statement` is now a named node. Previously an empty `;` produced
    no node at all (`_empty_statement` was a hidden `prec(-1, ';')` rule);
    now every stray or repeated semicolon — `;;`, `А = 1;;; Б = 2;`, a
    trailing `;` after a module-level `Перем` definition or after an
    `ERROR` recovery region, an empty line-holder `;` inside a block body —
    appears in the tree as an `(empty_statement)` node. Consumers walking
    statement children of block containers must expect and skip these
    nodes; `node-types.json` lists `empty_statement` among the children of
    every statement container.
  - Keyword-like member names no longer produce keyword nodes. After `.`,
    a property name or method name that coincides with a BSL keyword
    (`Структура.Функция`, `Псевдонимы.Неопределено`,
    `Объект.Перейти()`) is now lexed by a dedicated `member_name` token
    (same charset as `identifier`, including `ё`/`Ё`) and aliased to plain
    `property` / `identifier` leaves: `(property)` without keyword
    children, `name: (identifier)` without a `FUNCTION_KEYWORD` /
    `GOTO_KEYWORD` / etc. wrapper. Previously these positions produced
    `(property (FUNCTION_KEYWORD))` and `(identifier (GOTO_KEYWORD))`
    trees. As a side effect, `AND_KEYWORD` / `OR_KEYWORD` / `NOT_KEYWORD`
    are no longer reachable node types (they were only ever reachable as
    keyword-children of `identifier` / `property` in member positions, and
    as binary/unary operators they are aliased to `operator`), so the BSL
    highlight query dropped those three dead patterns — real `И` / `Или` /
    `Не` operators keep highlighting through the existing
    `(operator) @operator` pattern.
  - Recovery-tree changes for invalid inputs: the «Двойной незакрытый
    метод» doubly-unclosed-call form now flattens the member name into a
    `(property)` inside the `ERROR` node; `б = Не Не Готово` collects the
    stray `НЕ` as `(ERROR (operator))`; adjacent quoted strings
    (`Возврат "а" "б"`) recover as `(ERROR (identifier))`; the double-NOT
    method-call form (`НЕ НЕ Валюта.Пустая()`) now recovers as an `ERROR`
    over the two `НЕ` followed by a clean `call_statement` (see
    draft-coverage.bsl «НЕ НЕ с вызовом — невалидный BSL»). These inputs
    are invalid BSL and were already `ERROR`-rooted; only the recovery
    shape inside the `ERROR` node changed.

- Member and call access after a ternary now parses:
  `?(условие, а, б).Поле`, `?(условие, а, б).Метод()` and longer chains
  `?(…).РегистрыБухгалтерии.Содержит(х)` (issue #24; ssl_3_2 acceptance run).
  Grammar change: `ternary_expression` joins the bases of the recursive
  `access` rule. Node-shape: `access` gains the `ternary_expression` child
  type in `node-types.json`; a standalone ternary is unchanged (still
  `expression (ternary_expression …)`, never wrapped in `access`).
  `parenthesized_expression` is intentionally not added: `(А).Б` is invalid
  1C and keeps producing an ERROR. Corpus: new section «Доступ к свойству
  после тернарного оператора» in `expressions.bsl`.
- Method parameter default values now accept a sign: `Знач Количество = -1`,
  `Смещение = +2` (issue #24, 8 files in the ssl_3_2 acceptance run).
  Node-shape note: for a signed default the `def` field of `parameter` carries
  two entries — `def: (operator) def: (number)` — mirroring how
  `unary_expression` exposes its operator; the unsigned form `= 1` keeps the
  exact previous shape `def: (number)`. In `node-types.json` the `def` field
  becomes `multiple: true` and gains the `operator` child type. Corpus: new
  section «Значения параметров по умолчанию со знаком» in `methods.bsl`.
- Bare `ВызватьИсключение` (re-raise) is now a valid statement everywhere, not
  only inside a `Попытка … Исключение` block (issue #24, 35 files in the
  ssl_3_2 acceptance run). `ВызватьИсключение;` and `ВызватьИсключение` without
  the trailing `;` (as the last operator of a block) parse as
  `rise_error_statement` with only the `RAISE_KEYWORD` child. Node-shape
  migration: previously the standalone form produced an error-recovery tree
  `rise_error_statement (RAISE_KEYWORD) (expression (MISSING identifier))`;
  consumers must not expect the `MISSING` node anymore. Grammar change:
  `_exception_statement` collapses to `_statement` and the internal
  `_rise_error_rethrow_statement` rule/alias is removed (`rise_error_statement`
  covers both forms); `node-types.json` child list of
  `rise_error_statement` is unchanged (children stay optional-required mix,
  `RAISE_KEYWORD` alone is a valid tree).
- Ternary operator `?(…)` now accepts whitespace between `?` and `(`:
  `? (кондиция, а, б)` parses as the same `ternary_expression`. Found on the
  yaxunit@develop acceptance run (`УведомленияСервер/Module.bsl`, a single
  occurrence); the 1C platform accepts `? (`, so this is valid BSL. Grammar
  change: the anonymous token literal `'?('` in `ternary_expression` is
  replaced by the two literals `'?'` and `'('` (tree-sitter skips whitespace
  between them); no fields or named-children of `ternary_expression` change.
  Node-shape note: the anonymous token `"?("` in `node-types.json` is replaced
  by the pre-existing tokens `"?"` and `"("` — consumers matching the literal
  token type `"?("` must switch to `"?"`. Corpus: new section
  «ternary with space between ? and (» in `expressions.bsl`.
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
  (`parser.c` and the vendored `src/tree_sitter/array.h`); at the time of
  that sweep `grammar.json` and `node-types.json` were unchanged and the
  language ABI stayed 15. The statement-separator change later in this
  release DOES change `node-types.json` — see the node-shape migration
  entry above (named `empty_statement`, keyword member names).
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
