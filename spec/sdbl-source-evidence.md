# SDBL source evidence

This file records source evidence for the SDBL query-language grammar. Keep it
focused on parser syntax facts. Do not add analyzer, metadata or downstream
product facts here.

## Primary Source

Local source snapshot:

`spec/sdbl-syntax/`

Snapshot origin:

`/home/alko/develop/open-source/v8-context-hbk/target/help/shquery-ru/работа-с-запросами/синтаксис-текста-запросов`

The local snapshot currently contains 200 Markdown pages under the query syntax
root.

## Top-level Query Text

Source page:

`spec/sdbl-syntax/текст-запроса/index.md`

Observed rule:

```text
<Текст Запроса>
  <Описание запроса>
  [<Объединение запросов>]
  [<Упорядочивание результатов>]
  [АВТОУПОРЯДОЧИВАНИЕ]
  [<Описание итогов>]
```

Parser implication:

- the standalone SDBL root should represent query text, not BSL `source_file`;
- `Описание запроса` is mandatory;
- union, ordering, auto-ordering and totals are later optional top-level
  sections.

## Select Section

Source page:

`spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/index.md`

Observed clause order:

```text
ВЫБРАТЬ [РАЗРЕШЕННЫЕ] [РАЗЛИЧНЫЕ] [ПЕРВЫЕ <Количество>]
  <Список полей выборки>
[ПОМЕСТИТЬ <Имя временной таблицы>]
[ИЗ <Список источников>]
[ИНДЕКСИРОВАТЬ ПО <Список полей индексации>]
[ГДЕ <Условие отбора>]
[СГРУППИРОВАТЬ ПО <Поля группировки>]
[ИМЕЮЩИЕ <Условие отбора>]
[ДЛЯ ИЗМЕНЕНИЯ [[OF]<Список таблиц верхнего уровня>]]
```

Parser implication:

- `ВЫБРАТЬ` starts the mandatory query description;
- the first parser milestone can stop after fields, `ИЗ` and `ГДЕ`;
- later milestones should preserve documented clause order.

## Selection List

Source page:

`spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-выбрать/список-полей-выборки/index.md`

Observed facts:

- a selection list contains one or more comma-separated fields, or `*`;
- a field can have an optional alias;
- `КАК` before the alias is optional;
- a field description can be an expression;
- nested-table field groups and `ПУСТАЯТАБЛИЦА` exist but can be later
  milestones.

Parser implication:

- MVP should support comma-separated fields, `*`, expressions and aliases;
- nested-table field groups should be explicit later work, not hidden in a
  catch-all token.

## Data Sources

Source page:

`spec/sdbl-syntax/текст-запроса/секция-выбрать-описание-запроса/предложение-из/index.md`

Observed facts:

- `ИЗ` is optional when sources are fully determined by the selection list;
- source list entries are comma-separated;
- a source can have an optional alias;
- sources may include table names, virtual-table parameters or nested queries;
- joins are part of source descriptions.

Parser implication:

- MVP should support plain table sources and aliases;
- virtual-table parameters, nested queries and joins are later milestones.

## Expressions

Source page:

`spec/sdbl-syntax/использование-выражений-в-языке-запросов/index.md`

Observed expression categories:

- field dereference;
- aggregate functions;
- query-language functions;
- choice operation;
- type cast;
- literal or parameter values;
- binary operations;
- unary operations;
- parenthesized expressions.

Parser implication:

- MVP expressions should cover literals, parameters, field dereference,
  comparison and boolean composition;
- query functions, aggregate functions, `ВЫБОР` and `ВЫРАЗИТЬ` are later
  milestones unless needed by an MVP corpus case.
