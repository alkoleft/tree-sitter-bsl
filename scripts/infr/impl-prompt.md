[$implementation-orchestrator](/home/alko/.codex/skills/implementation-orchestrator/SKILL.md) следующую незавершенную задачу из активного parser ledger в `spec/IMPLEMENTATION_TODO.md`.

## Главный порядок

`tree-sitter-bsl` владеет только grammar behavior и parser-facing contracts:

- `grammar.js` как исходная грамматика;
- `test/corpus/*.bsl` как поведенческий regression contract;
- `src/grammar.json`, `src/node-types.json`, `src/parser.c` и binding-facing generated artifacts,
  когда изменение грамматики требует генерации;
- Node, Rust и Python bindings только как поверхности интеграции parser package.

`spec/IMPLEMENTATION_TODO.md` является активным ledger для parser work. README - пользовательская
ориентация и документация по использованию пакета, а не implementation ledger. Если README, chat
notes, комментарии или task text конфликтуют с ledger, сначала согласуй контракт в
`spec/IMPLEMENTATION_TODO.md`.

Выбирай первую незавершенную задачу из `spec/IMPLEMENTATION_TODO.md` и выполняй только ее. Если
ledger изменен человеком, считай его актуальным: не перескакивай к более интересной задаче и не
расширяй scope на downstream analyzer behavior.

## Обязательный контекст перед реализацией

- проверь `git status --short` и отдели уже существующие изменения от изменений текущей задачи;
- прочитай выбранную задачу в `spec/IMPLEMENTATION_TODO.md`;
- прочитай relevant `grammar.js` rules для выбранной syntax behavior;
- прочитай existing focused corpus files в `test/corpus/*.bsl`, которые ближе всего к выбранному
  синтаксису;
- если задача основана на `lezer-bsl`, используй его snippets только как candidate input examples:
  не копируй Lezer AST node names, visitors или failing expectations как tree-sitter contract;
- если задача меняет public node shape, заранее определи, где это должно быть отражено:
  corpus expectations, generated node types, README/release notes или ledger.

## Grammar rules

- тестируй и реализуй конкретное BSL syntax behavior, а не широкие approximations;
- предпочитай precise grammar rules вместо catch-all tokens;
- не принимай invalid BSL только ради отсутствия `ERROR` nodes;
- сохраняй structured preprocessor parsing для `#Если` / `#Область`; не заменяй его generic
  skipped-line token;
- сохраняй существующие node shapes там, где это практично;
- если node-shape migration необходима, зафиксируй ее в corpus tests и durable notes;
- неизвестный или намеренно unsupported syntax оставляй явным в ledger, а не прячь в ad-hoc probes.

## Рабочий порядок

1. Сделай короткий план после чтения ledger, grammar и связанных corpus cases.
2. Добавь или обнови focused corpus cases до изменения grammar behavior.
3. Реализуй только выбранную syntax behavior и ее direct verification.
4. Regenerate parser artifacts, если изменился `grammar.js`.
5. Обнови `spec/IMPLEMENTATION_TODO.md`, README или release notes только когда durable parser
   contract, validation command или public node shape действительно изменились.
6. Отмечай задачу завершенной в `spec/IMPLEMENTATION_TODO.md` только после успешной проверки.
7. После успешной проверки и отметки ledger создай git commit с узким scope выбранной задачи:
   stage только относящиеся к задаче файлы, проверь staged diff и не включай существующие
   пользовательские или unrelated изменения.

## Проверка

- `npm test` проверяет загрузку Node binding;
- `tree-sitter test` проверяет corpus expectations, когда локальный CLI работает;
- targeted Node binding probes допустимы только как временная диагностика, если `tree-sitter test`
  заблокирован на текущем host;
- после grammar changes проверь, что generated artifacts согласованы с `grammar.js`;
- перед коммитом проверь `git diff --check`, `git diff --cached --name-only` и staged diff.
- задача не считается завершенной, пока проверенный scoped diff не закоммичен либо пока явный blocker
  не описан в итоговом ответе.

Если `tree-sitter test` заблокирован текущей средой, не скрывай это: опиши blocker и приложи
targeted probe evidence, достаточный для выбранной задачи.

## Ограничения

- не откатывай существующие пользовательские или предварительно подготовленные изменения;
- если существующие изменения конфликтуют с выбранной задачей, остановись и опиши конфликт;
- не добавляй analyzer facts, diagnostics, metadata models, HBK facts, query tools, report formats
  или downstream product behavior;
- не вводи broad compatibility layers, hidden fallbacks, generic parser pipelines или downstream
  consumer adapters;
- не мутируй external checkouts при parser validation;
- не создавай пустой коммит, если по выбранной задаче нет изменений.
