# SDBL query-language grammar specification

## Purpose

Add standalone tree-sitter grammar coverage for the 1C query language, named
`sdbl`, in this repository.

This specification is the durable parser contract for the SDBL grammar. The
implementation ledger remains `spec/IMPLEMENTATION_TODO.md`.

## Source Material

Primary syntax source snapshot:

`spec/sdbl-syntax/`

Snapshot origin:

`/home/alko/develop/open-source/v8-context-hbk/target/help/shquery-ru/работа-с-запросами/синтаксис-текста-запросов`

Evidence extracted from that source is tracked in
`spec/sdbl-source-evidence.md`.

## Scope

The SDBL grammar owns parser-facing query-language syntax:

- the statement-level `source_file` root for single query texts,
  semicolon-separated query packages and standalone temporary-table statements;
- query text structure;
- query clauses and clause ordering;
- query expressions;
- query literals and parameters;
- field dereference and table-source syntax;
- comments;
- generated parser artifacts and corpus tests for the `sdbl` grammar.

The grammar does not own:

- analyzer facts or diagnostics;
- metadata models;
- HBK fact extraction;
- query execution behavior;
- report formats;
- downstream product behavior;
- semantic validation that requires a configuration or platform runtime.

## Repository Layout

Current layout:

```text
grammars/bsl/grammar.js            # BSL source grammar
grammars/bsl/src/                  # BSL generated artifacts
grammars/bsl/test/corpus/*.bsl     # BSL corpus tests
grammars/bsl/queries/              # BSL highlights and SDBL injections
grammars/sdbl/grammar.js           # SDBL source grammar
grammars/sdbl/src/                 # SDBL generated artifacts
grammars/sdbl/test/corpus/*.sdbl   # SDBL corpus tests
grammars/sdbl/queries/             # SDBL highlights
```

Both grammars are registered in `tree-sitter.json` with explicit
`grammars/<name>` paths.

## Naming Contract

- Grammar name: `sdbl`.
- Tree-sitter scope: `source.sdbl`.
- Standalone file extension for corpus and parser checks: `.sdbl`.
- Public node names must describe query syntax, for example
  `query`, `select_section`, `select_clause`, `from_clause`, `where_clause`,
  `field_list`, `field`, `table_source`, `query_expression`.
- Do not copy Russian help-rule titles directly as node names when a concise
  English parser node name is clearer.
- Keep keyword tokens case-insensitive.

## Parser Contract

The SDBL grammar parses standalone query texts and query packages:

```sdbl
ВЫБРАТЬ
    Справочник.Номенклатура.Ссылка
ИЗ
    Справочник.Номенклатура КАК Номенклатура
```

```sdbl
ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 10
    Номенклатура.Ссылка КАК Ссылка,
    Номенклатура.Наименование
ИЗ
    Справочник.Номенклатура КАК Номенклатура
ГДЕ
    Номенклатура.ПометкаУдаления = ЛОЖЬ
```

```sdbl
ВЫБРАТЬ
    Номенклатура.Ссылка
ИЗ
    Справочник.Номенклатура КАК Номенклатура;

УНИЧТОЖИТЬ ВременнаяТаблица
```

Current syntax coverage:

- `ВЫБРАТЬ`;
- optional `РАЗРЕШЕННЫЕ`, `РАЗЛИЧНЫЕ`, `ПЕРВЫЕ <number>`;
- selection list with comma-separated fields, `*`, nested table field groups
  and `ПУСТАЯТАБЛИЦА`;
- optional field aliases with and without `КАК`;
- dotted field and table names;
- `ИЗ` with comma-separated sources, optional aliases, virtual-table
  parameters, nested query sources, nested table sources and joins;
- clauses `ПОМЕСТИТЬ`, `ДОБАВИТЬ`, `ГДЕ`, `СГРУППИРОВАТЬ ПО`, `ИМЕЮЩИЕ`,
  `ДЛЯ ИЗМЕНЕНИЯ`, `ИНДЕКСИРОВАТЬ ПО`;
- top-level `ОБЪЕДИНИТЬ`, `ОБЪЕДИНИТЬ ВСЕ`, `УПОРЯДОЧИТЬ ПО`,
  `АВТОУПОРЯДОЧИВАНИЕ` and `ИТОГИ`;
- standalone `УНИЧТОЖИТЬ <temporary table>`;
- semicolon-separated query packages;
- expressions: comparison, boolean, arithmetic, unary, membership, `МЕЖДУ`,
  `ПОДОБНО`, `ЕСТЬ NULL`, `ССЫЛКА`, `ВЫБОР`, `ВЫРАЗИТЬ`;
- literals: number, string, date, `ДАТАВРЕМЯ(...)`, `ТИП(...)`,
  `ЗНАЧЕНИЕ(...)`, `NULL`, `ИСТИНА`, `ЛОЖЬ`, `НЕОПРЕДЕЛЕНО`;
- query parameters such as `&Параметр`;
- ordinary query functions as generic `function_call` nodes and aggregate
  functions as `aggregate_function` nodes;
- line comments.

The detailed page-by-page status for the vendored help snapshot is maintained
in `spec/sdbl-coverage-matrix.md`.

## Completed Integration Milestones

- SDBL binding/package exposure exists for Node.js, Rust, Python, Go and C.
- Package query files ship BSL/SDBL highlight queries and BSL string injection
  metadata.
- Static BSL string injection is implemented through tree-sitter query/editor
  composition, governed by ADR-0002. It does not change BSL node shapes.
- The local Zed dev extension contains an `sdbl_embedded` carrier grammar for
  raw injected BSL string content.

## Corpus Rules

- Add SDBL corpus cases before grammar behavior changes.
- Keep corpus sections small and grouped by syntax feature.
- Expected trees are the tree-sitter SDBL contract, not direct copies of help
  rule names.
- Use deterministic query snippets.
- Use real project query texts only as read-only acceptance inputs, never as
  mutated fixtures in external checkouts.

## Validation

Normal validation:

```sh
tree-sitter generate --output grammars/sdbl/src grammars/sdbl/grammar.js
npm run test:corpus
npm test
```

`npm run test:corpus` uses the package-local `tree-sitter-cli` and validates
both BSL and SDBL corpus expectations. A system tree-sitter CLI that supports
`-p` can validate individual grammars with:

```sh
tree-sitter test -p grammars/bsl
tree-sitter test -p grammars/sdbl
```

The package-local `tree-sitter-cli` is pinned to `0.25.10`; on this host it
works for local validation but does not support `test -p`.

## Non-goals

- Do not merge SDBL syntax into the BSL grammar.
- Do not change the BSL AST shape for query support.
- Do not implement semantic checks that require platform metadata.
- Do not accept invalid query syntax only to avoid `ERROR` nodes.
