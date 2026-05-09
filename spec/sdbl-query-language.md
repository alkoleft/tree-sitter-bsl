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

Initial target layout:

```text
grammar.js                         # existing BSL grammar
src/                               # existing BSL generated artifacts
test/corpus/                       # existing BSL corpus
grammars/sdbl/grammar.js           # SDBL source grammar
grammars/sdbl/src/                 # SDBL generated artifacts
grammars/sdbl/test/corpus/*.sdbl   # SDBL corpus tests
grammars/sdbl/queries/             # SDBL queries, when needed
```

The SDBL grammar should be added to `tree-sitter.json` after the scaffold is
generated and locally validated.

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

## MVP Parser Contract

The first SDBL implementation should parse focused standalone query texts:

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

MVP syntax coverage:

- `ВЫБРАТЬ`;
- optional `РАЗРЕШЕННЫЕ`, `РАЗЛИЧНЫЕ`, `ПЕРВЫЕ <number>`;
- selection list with comma-separated fields and `*`;
- optional field aliases with and without `КАК`;
- dotted field and table names;
- `ИЗ` with comma-separated sources and optional aliases;
- `ГДЕ` with basic comparison and boolean expressions;
- literals: number, string, date, `NULL`, `ИСТИНА`, `ЛОЖЬ`,
  `НЕОПРЕДЕЛЕНО`;
- query parameters such as `&Параметр`;
- line comments.

## Later Parser Milestones

1. Full select-section clauses:
   `ПОМЕСТИТЬ`, `ИНДЕКСИРОВАТЬ ПО`, `СГРУППИРОВАТЬ ПО`, `ИМЕЮЩИЕ`,
   `ДЛЯ ИЗМЕНЕНИЯ`.
2. Source descriptions:
   virtual-table parameters, nested queries, nested tables and joins.
3. Query expressions:
   arithmetic operators, logical operators, parentheses, `В`, `МЕЖДУ`,
   `ПОДОБНО`, `ЕСТЬ NULL`, `ССЫЛКА`, `ВЫБОР`, `ВЫРАЗИТЬ`.
4. Query functions and aggregate functions.
5. Top-level sections after the first query description:
   `ОБЪЕДИНИТЬ`, `ОБЪЕДИНИТЬ ВСЕ`, `УПОРЯДОЧИТЬ ПО`,
   `АВТОУПОРЯДОЧИВАНИЕ`, `ИТОГИ`.
6. Binding/package exposure for SDBL consumers.
7. Future BSL string injection through parser composition, governed by
   ADR-0002, only after tests prove that static BSL string content is injected
   as `source.sdbl` without changing the BSL AST shape.

## Corpus Rules

- Add SDBL corpus cases before grammar behavior changes.
- Keep corpus sections small and grouped by syntax feature.
- Expected trees are the tree-sitter SDBL contract, not direct copies of help
  rule names.
- Use deterministic query snippets.
- Use real project query texts only as read-only acceptance inputs, never as
  mutated fixtures in external checkouts.

## Validation

Normal validation after SDBL scaffold exists:

```sh
tree-sitter generate --output grammars/sdbl/src grammars/sdbl/grammar.js
tree-sitter test -p grammars/sdbl
tree-sitter test
npm test
```

`tree-sitter test -p grammars/sdbl` validates SDBL corpus expectations.
`tree-sitter test` validates the existing BSL corpus from the repository root.
`npm test` protects the existing package binding surface until SDBL bindings are
explicitly added.

## Non-goals for the First Implementation

- Do not parse SDBL inside BSL string literals.
- Do not change the BSL AST shape for query support.
- Do not expose SDBL through Node, Rust, Python or Go bindings before the
  standalone grammar and corpus are stable.
- Do not implement semantic checks that require platform metadata.
- Do not accept invalid query syntax only to avoid `ERROR` nodes.
