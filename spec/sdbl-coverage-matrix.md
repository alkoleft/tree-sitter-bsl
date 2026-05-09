# SDBL syntax coverage matrix

This matrix is the page-by-page parser-scope inventory for the vendored 1C
query-language syntax snapshot under `spec/sdbl-syntax/`.

It is intentionally limited to grammar behavior and parser-facing contracts.
Analyzer facts, metadata validation, runtime semantics, query execution and
downstream report behavior are out of scope.

## Status values

- `covered`: the current `sdbl` grammar has a direct parser rule and corpus
  coverage for the page's syntax shape, or the page is a parent page covered by
  its listed child syntax shapes.
- `covered-by-generic-expression`: the syntax parses through an intentionally
  generic expression rule such as `function_call`, `aggregate_function`,
  `binary_expression`, `unary_expression` or `_qualified_name`. These pages
  point to focused corpus sections when catalog completeness is part of the
  parser contract.
- `planned`: the current parser contract needs a grammar or node-shape task.
- `semantic-only`: the page primarily describes runtime, metadata or semantic
  behavior that the grammar must not validate.
- `duplicate-reference`: the page duplicates a syntax item covered by another
  canonical page.
- `out-of-parser-scope`: navigation, bilingual reference or diagram material
  that does not define an additional parser contract.

## Task map

Active follow-up tasks:

- SDBL-22: expand real-query acceptance with read-only WMS query examples.

Completed tasks:

- SDBL-23: query-package texts with semicolon-separated queries.
- SDBL-12: selection-list nested-table field groups and `ПУСТАЯТАБЛИЦА`.
- SDBL-15: source-description corpus closure for `ИЗ`, nested queries, nested
  table sources, aliases and joins in `select.sdbl`.
- SDBL-16: top-level query text section corpus closure for unions, ordering,
  auto-ordering and totals variants.
- SDBL-19: `ДОБАВИТЬ <Имя временной таблицы>` select-section clause.
- SDBL-20: standalone temporary-table `УНИЧТОЖИТЬ` statement.
- SDBL-21: ordinary query functions intentionally remain generic
  `function_call` nodes; function-family classification is downstream.

## Coverage summary

- Source pages inventoried: 200.
- Remaining grammar/node-shape tasks: none.
- Remaining corpus-completeness tasks over already-supported syntax families:
  SDBL-22.

## Page matrix

| Source page | Decision | Parser note / task |
| --- | --- | --- |
| `index.md` | out-of-parser-scope | Snapshot root/navigation page. |
| `двуязычное-представление-ключевых-слов` | out-of-parser-scope | Keyword spelling reference; grammar keeps case-insensitive Russian/English keyword tokens where implemented. |
| `использование-выражений-в-языке-запросов` | covered | Parent expression overview; child pages below split parser-scope syntax. |
| `использование-выражений-в-языке-запросов/агрегатные-функции` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus completeness. |
| `использование-выражений-в-языке-запросов/агрегатные-функции/количество` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/агрегатные-функции/максимум` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/агрегатные-функции/минимум` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/агрегатные-функции/среднее` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/агрегатные-функции/сумма` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/бинарные-операции` | covered-by-generic-expression | `binary_expression`; `catalog.sdbl` covers operator catalog corpus. |
| `использование-выражений-в-языке-запросов/использование-предопределенных-данных-конфигурации` | covered | `predefined_value_literal`; object existence is semantic-only. |
| `использование-выражений-в-языке-запросов/логические-выражения` | covered | Parent logical-expression page; concrete operators split below. |
| `использование-выражений-в-языке-запросов/логические-выражения/в-оператор-проверки-совпадения-значения` | covered | `membership_expression`; `catalog.sdbl` covers operator catalog corpus. |
| `использование-выражений-в-языке-запросов/логические-выражения/в-оператор-проверки-совпадения-значения/проверка-принадлежности-по-иерархии` | covered | `membership_expression` with `HIERARCHY_KEYWORD`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/в-оператор-проверки-совпадения-значения/проверка-совпадения-значения-с-одним-из-результата-запроса` | covered | `membership_expression` with `subquery_expression`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/в-оператор-проверки-совпадения-значения/проверка-совпадения-с-одним-из-перечисленных` | covered | `membership_expression` with `value_list`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/есть-null-оператор-проверки-значения-на-null` | covered | `null_check_expression`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/между-оператор-проверки-вхождения-значения-в-диапазон` | covered | `between_expression`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/операция-сравнения` | covered-by-generic-expression | `comparison_operator`; `catalog.sdbl` covers operator corpus. |
| `использование-выражений-в-языке-запросов/логические-выражения/операция-сравнения/правила-сравнения-значений` | semantic-only | Runtime comparison semantics; no grammar contract beyond comparison operators. |
| `использование-выражений-в-языке-запросов/логические-выражения/подобно-оператор-проверки-строки-на-подобие-шаблону` | covered | `like_expression` including optional `СПЕЦСИМВОЛ`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/список-значений` | covered | `value_list`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/логические-выражения/ссылка-оператор-проверки-ссылочного-значения` | covered | `reference_check_expression`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/операция-выбора-выбор` | covered | `case_expression`; `catalog.sdbl` covers operator corpus. |
| `использование-выражений-в-языке-запросов/приведение-типа-выразить` | covered | `cast_expression`; `catalog.sdbl` covers operator corpus. |
| `использование-выражений-в-языке-запросов/разыменование-полей` | covered-by-generic-expression | `_qualified_name` / `dotted_identifier`; `catalog.sdbl` covers corpus completeness. |
| `использование-выражений-в-языке-запросов/унарные-операции` | covered-by-generic-expression | `unary_expression`; `catalog.sdbl` covers operator corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов` | covered-by-generic-expression | Ordinary query functions parse as `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/год` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/день` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/деньгода` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/деньнедели` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/добавитькдате` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/естьnull` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/квартал` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/конецпериода` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/месяц` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/минута` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/началопериода` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/неделя` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/подстрока` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/представление` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/представлениессылки` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/разностьдат` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/секунда` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/типзначения` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `использование-выражений-в-языке-запросов/функции-языка-запросов/час` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции` | out-of-parser-scope | Keyword/function index page. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами` | duplicate-reference | Parent index for temporary-table keywords; concrete pages below map to select clauses or semantic-only commands. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/добавить` | covered | `add_clause`; `select.sdbl` covers `ДОБАВИТЬ <Имя временной таблицы>`. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/индексировать-по-наборам` | semantic-only | Runtime indexing behavior for temporary-table packages; no separate grammar shape beyond `ИНДЕКСИРОВАТЬ ПО`. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/индексировать-по` | covered | `index_by_clause`; catalog corpus covered in `catalog.sdbl`, select corpus covers placement after `ГДЕ`. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/поместить` | covered | `into_clause`; catalog corpus covered in `catalog.sdbl`. |
| `ключевые-слова-и-функции/ключевые-слова-для-работы-с-временными-таблицами/уничтожить` | covered | `destroy_statement`; `select.sdbl` covers standalone `УНИЧТОЖИТЬ <Имя временной таблицы>`. |
| `ключевые-слова-и-функции/константы-и-параметры-значение` | covered | Parent literal/parameter catalog; dedicated special forms are split below. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/null` | covered | `null`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/имя-параметра` | covered | `parameter`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/истина` | covered | `boolean`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/литерал-типа-дата` | covered | `date_time_literal`; existing quoted `date` token also remains available. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/литерал-типа-строка` | covered | `string`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/литерал-типа-тип` | covered | `type_literal`. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/литерал-типа-число` | covered | `number`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/ложь` | covered | `boolean`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/константы-и-параметры-значение/неопределено` | covered | `undefined`; literal catalog corpus coverage. |
| `ключевые-слова-и-функции/общие-ключевые-слова` | duplicate-reference | Keyword index; concrete parser decisions are on child pages. |
| `ключевые-слова-и-функции/общие-ключевые-слова/автоупорядочивание` | covered | `auto_order_clause`; SDBL-16 completed variant corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать` | covered | `select_section`; child pages cover options and field list. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать/как` | covered | `field_alias`; duplicate of field-alias pages. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать/первые` | covered | `top_clause`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать/пустаятаблица` | covered | `empty_table_expression` with `EMPTY_TABLE_KEYWORD` and `empty_table_field_list`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать/различные` | covered | `DISTINCT_KEYWORD`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/выбрать/разрешенные` | covered | `ALLOWED_KEYWORD`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/где` | covered | `where_clause`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из` | covered | `from_clause`; SDBL-15 completed source-description corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из/внутреннее-соединение` | covered | `join_clause` / `join_kind`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из/как` | covered | `source_alias`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из/левое-внешнее-соединение` | covered | `join_clause` / `join_kind`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из/полное-внешнее-соединение` | covered | `join_clause` / `join_kind`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/из/правое-внешнее-соединение` | covered | `join_clause` / `join_kind`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/имеющие` | covered | `having_clause`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по` | covered | `totals_clause`; SDBL-16 completed variant corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по/итоги-по-общие` | covered | `totals_clause` with `GENERAL_KEYWORD`; SDBL-16 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по/как` | covered | `totals_field` / `totals_group` aliases; SDBL-16 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по/периодами` | covered | `totals_periods_clause`; SDBL-16 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/итоги-по/только-иерархия` | covered | `totals_group` optional `ONLY_KEYWORD` and `HIERARCHY_KEYWORD`; SDBL-16 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/как` | duplicate-reference | Alias/type-cast keyword parent; child pages map to concrete syntax. |
| `ключевые-слова-и-функции/общие-ключевые-слова/как/приведение-типа` | duplicate-reference | Same parser contract as `cast_expression`. |
| `ключевые-слова-и-функции/общие-ключевые-слова/как/псевдонимы-источников-данных` | covered | `source_alias`; SDBL-15 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/как/псевдонимы-итогов` | covered | `totals_field` / `totals_group` aliases; SDBL-16 completed corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/как/псевдонимы-полей-выборки` | covered | `field_alias`; SDBL-12 covers nested-table aliases. |
| `ключевые-слова-и-функции/общие-ключевые-слова/объединить` | covered | `union_clause`; SDBL-16 completed variant corpus closure. |
| `ключевые-слова-и-функции/общие-ключевые-слова/сгруппировать-по` | covered | `group_by_clause`; nested-table semantic restrictions are not grammar-owned. |
| `ключевые-слова-и-функции/общие-ключевые-слова/упорядочить-по` | covered | `order_by_clause`; SDBL-16 completed variant corpus closure. |
| `ключевые-слова-и-функции/операторы` | duplicate-reference | Operator index; concrete pages map below. |
| `ключевые-слова-и-функции/операторы/арифметические-операторы` | covered-by-generic-expression | `binary_expression` arithmetic operators; `catalog.sdbl` covers corpus completeness. |
| `ключевые-слова-и-функции/операторы/логические-операторы` | covered | Logical operator parent. |
| `ключевые-слова-и-функции/операторы/логические-операторы/в-иерархии` | duplicate-reference | Same parser contract as membership with hierarchy. |
| `ключевые-слова-и-функции/операторы/логические-операторы/в` | duplicate-reference | Same parser contract as membership. |
| `ключевые-слова-и-функции/операторы/логические-операторы/есть-null` | duplicate-reference | Same parser contract as null check. |
| `ключевые-слова-и-функции/операторы/логические-операторы/между` | duplicate-reference | Same parser contract as between. |
| `ключевые-слова-и-функции/операторы/логические-операторы/подобно` | duplicate-reference | Same parser contract as like. |
| `ключевые-слова-и-функции/операторы/логические-операторы/ссылка` | duplicate-reference | Same parser contract as reference check. |
| `ключевые-слова-и-функции/операторы/прочие-операторы` | duplicate-reference | Parent for `ВЫБОР` and `ВЫРАЗИТЬ`. |
| `ключевые-слова-и-функции/операторы/прочие-операторы/выбор` | duplicate-reference | Same parser contract as `case_expression`. |
| `ключевые-слова-и-функции/операторы/прочие-операторы/выразить` | duplicate-reference | Same parser contract as `cast_expression`. |
| `ключевые-слова-и-функции/прочее` | duplicate-reference | Parent for special literal forms. |
| `ключевые-слова-и-функции/прочее/датавремя` | covered | `date_time_literal`. |
| `ключевые-слова-и-функции/прочее/значение` | covered | `predefined_value_literal`; metadata existence is semantic-only. |
| `ключевые-слова-и-функции/прочее/тип` | covered | `type_literal`. |
| `ключевые-слова-и-функции/функции` | covered-by-generic-expression | Function catalog parent; ordinary calls parse as `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции/количество` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции/максимум` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции/минимум` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции/среднее` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/агрегатные-функции/сумма` | covered-by-generic-expression | `aggregate_function`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/acos` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/asin` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/atan` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/cos` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/exp` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции` | covered-by-generic-expression | Function group parent; ordinary calls parse as `function_call`. |
| `ключевые-слова-и-функции/функции/математические-функции/log` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/log10` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/pow` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/sin` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/sqrt` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/окр` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/математические-функции/цел` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции` | covered-by-generic-expression | Function group parent; ordinary calls parse as `function_call`. |
| `ключевые-слова-и-функции/функции/прочие-функции/естьnull` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/представление` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/представлениессылки` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/размерхранимыхданных` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/сгруппированопо` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/типзначения` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/прочие-функции/уникальныйидентификатор` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-для-работы-с-временными-таблицами` | covered-by-generic-expression | Function group parent; ordinary calls parse as `function_call`. |
| `ключевые-слова-и-функции/функции/функции-для-работы-с-временными-таблицами/автономерзаписи` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами` | covered-by-generic-expression | Function group parent; ordinary calls parse as `function_call`. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/год` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/день` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/деньгода` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/деньнедели` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/добавитькдате` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/квартал` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/конецпериода` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/месяц` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/минута` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/началопериода` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/неделя` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/разностьдат` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/секунда` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-с-датами/час` | duplicate-reference | Same parser contract as date function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками` | covered-by-generic-expression | Function group parent; ordinary calls parse as `function_call`. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/врег` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/длинастроки` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/лев` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/нрег` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/подстрока` | duplicate-reference | Same parser contract as query-function catalog page. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/прав` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/сокрл` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/сокрлп` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/сокрп` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/стрзаменить` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/стрнайти` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `ключевые-слова-и-функции/функции/функции-работы-со-строками/строка` | covered-by-generic-expression | Ordinary `function_call`; `catalog.sdbl` covers catalog corpus. |
| `комментарии-в-языке-запросов` | covered | `line_comment`. |
| `синтаксическая-диаграмма-конструкций-языка-запросов` | out-of-parser-scope | Diagram overview; child syntax pages define parser contracts. |
| `текст-запроса` | covered | `query`; `query_package` covers semicolon-separated package texts; SDBL-16 completed top-level section variants. |
| `текст-запроса/автоупорядочивание` | covered | `auto_order_clause`; SDBL-16 completed variant corpus closure. |
| `текст-запроса/секция-выбрать-описание-запроса` | covered | `select_section` with documented clause order. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-выбрать` | covered | `SELECT_KEYWORD`, options and `field_list`; SDBL-12 covers nested field groups. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-выбрать/список-полей-выборки` | covered | `field_list`, `field`, `field_alias`; SDBL-12 covers nested field groups. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-выбрать/список-полей-выборки/вложенные-таблицы-в-списке-полей-выборки` | covered | `nested_table_field_expression`, `nested_field_group`, `nested_field_list` and `nested_field`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-где` | covered | `where_clause`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-где/условие-отбора` | covered | `query_expression`; operator catalog corpus covered in `catalog.sdbl`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-для-изменения` | covered | `for_update_clause`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-добавить` | covered | `add_clause`; `select.sdbl` covers `ДОБАВИТЬ <Имя временной таблицы>`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из` | covered | `from_clause`, `source_list`, `table_source`; `select.sdbl` covers comma-separated sources. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/описание-вложенного-запроса` | covered | `nested_query_source`; `select.sdbl` covers nested query sources. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/описание-вложенной-таблицы` | covered | Nested table source paths parse as source-position `dotted_identifier`; `select.sdbl` covers this stable node shape. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/псевдонимы-источников-данных` | covered | `source_alias`; `select.sdbl` covers aliases with and without `КАК`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/соединение` | covered | `join_clause`; `select.sdbl` covers repeated joins and joined nested query sources. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/соединение/внутреннее-соединение` | covered | `join_kind` inner; `select.sdbl` covers explicit `ВНУТРЕННЕЕ` and omitted inner kind. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/соединение/левое-внешнее-соединение` | covered | `join_kind` left outer; `select.sdbl` covers `ЛЕВОЕ` and `ЛЕВОЕ ВНЕШНЕЕ`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/соединение/полное-внешнее-соединение` | covered | `join_kind` full outer; `select.sdbl` covers `ПОЛНОЕ ВНЕШНЕЕ`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-из/соединение/правое-внешнее-соединение` | covered | `join_kind` right outer; `select.sdbl` covers `ПРАВОЕ` without optional `ВНЕШНЕЕ`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-имеющие` | covered | `having_clause`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-индексировать-по` | covered | `index_by_clause`; `select.sdbl` covers placement after `ГДЕ`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-поместить` | covered | `into_clause`. |
| `текст-запроса/секция-выбрать-описание-запроса/предложение-сгруппировать-по` | covered | `group_by_clause`. |
| `текст-запроса/секция-итоги-описание-итогов` | covered | `totals_clause`; SDBL-16 completed variant corpus closure. |
| `текст-запроса/секция-итоги-описание-итогов/псевдонимы-итогов` | covered | `totals_field` / `totals_group` aliases; SDBL-16 completed corpus closure. |
| `текст-запроса/секция-итоги-описание-итогов/расчет-общих-итогов` | covered | `GENERAL_KEYWORD` in `totals_clause`; SDBL-16 completed corpus closure. |
| `текст-запроса/секция-итоги-описание-итогов/совместное-использование-итогов-и-группировки` | semantic-only | Cross-clause result semantics; grammar only owns clause order and syntax. |
| `текст-запроса/секция-объединить-все-объединение-запросов` | covered | `union_clause` with optional `ALL_KEYWORD`; SDBL-16 completed corpus closure. |
| `текст-запроса/секция-упорядочить-по-упорядочивание-результатов` | covered | `order_by_clause`; SDBL-16 completed variant corpus closure. |
| `текст-запроса/секция-упорядочить-по-упорядочивание-результатов/упорядочивание-во-вложенных-таблицах` | covered-by-generic-expression | Ordering field paths parse as `dotted_identifier`; nested-table semantics are runtime behavior. |
| `текст-запроса/секция-упорядочить-по-упорядочивание-результатов/упорядочивание-по-иерархии` | covered | `ordering_direction` with `HIERARCHY_KEYWORD`; SDBL-16 completed corpus closure. |
