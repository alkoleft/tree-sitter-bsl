# tree-sitter-hbk

[![CI][ci]](https://github.com/mussolene/tree-sitter-bsl/actions/workflows/ci.yml)
[![npm][npm]](https://www.npmjs.com/package/tree-sitter-hbk)
[![crates.io][crates]](https://crates.io/crates/tree-sitter-hbk)
[![PyPI][pypi]](https://pypi.org/project/tree-sitter-hbk/)

Грамматика 1C BSL в формате [tree-sitter](https://github.com/tree-sitter/tree-sitter).
Пакет также содержит отдельную грамматику `sdbl` для языка запросов 1C.

[Попробовать](https://mussolene.github.io/tree-sitter-bsl/)

![playground](playground.png)

## Что входит

- `bsl`: грамматика исходных файлов BSL (`.bsl`, `.osl`).
- `sdbl`: грамматика самостоятельных текстов запросов 1C (`.sdbl`).
- Query-файлы tree-sitter для подсветки BSL/SDBL и внедрения статических
  строковых литералов BSL, начинающихся с `ВЫБРАТЬ`, `SELECT`, `УНИЧТОЖИТЬ`
  или `DROP`, как `sdbl`.
- Локальное dev-расширение Zed в [`editors/zed-bsl`](editors/zed-bsl) для
  проверки подсветки BSL, самостоятельного SDBL и внедренного SDBL.

BSL и SDBL остаются разными контрактами парсера. Грамматика BSL не встраивает
SDBL в AST строковых литералов; разбор встроенных запросов выполняется через
tree-sitter injections и композицию на стороне редактора.

## Локальная разработка

Локальный tree-sitter playground запускается отдельно для каждой грамматики:

```sh
npm start
npm run start:bsl
npm run start:sdbl
```

`npm start` является псевдонимом для BSL playground. `npm run start:sdbl`
запускает playground самостоятельной грамматики SDBL. При необходимости можно
собрать оба WASM-парсера:

```sh
npm run build:wasm
```

Быстрая проверка дерева разбора:

```sh
npm run parse:bsl -- examples/playground/basic.bsl
npm run parse:sdbl -- examples/playground/select.sdbl
```

Небольшие примеры для playground лежат в
[`examples/playground`](examples/playground):

- [`basic.bsl`](examples/playground/basic.bsl) для синтаксиса исходных файлов
  BSL;
- [`select.sdbl`](examples/playground/select.sdbl) и
  [`query-package.sdbl`](examples/playground/query-package.sdbl) для синтаксиса
  самостоятельных SDBL-запросов.

SDBL-примеры разбираются самостоятельной грамматикой SDBL. BSL-строки с
текстом запроса остаются узлами строк BSL; разбор встроенного запроса относится
к отдельному контракту injection/composition.

Основные команды проверки:

```sh
npm run test:corpus
npm test
npm run test:all
```

`npm run test:corpus` использует локальный для пакета `tree-sitter-cli` и
проверяет оба набора corpus-тестов. Для системного `tree-sitter` CLI, который
поддерживает `-p`, эквивалентные команды:

```sh
tree-sitter test -p grammars/bsl
tree-sitter test -p grammars/sdbl
```

## Использование

### Rust

Добавьте зависимость в [`Cargo.toml`](Cargo.toml):

```toml
[dependencies]
tree-sitter = "0.25"
tree-sitter-hbk = "0.1"
```

```rust
use tree_sitter::Parser;

fn main() {
    let mut parser = Parser::new();
    parser
        .set_language(&tree_sitter_hbk::LANGUAGE.into())
        .expect("Error loading BSL grammar");

    let source = r#"
        Процедура Привет()
            Сообщить("Привет, мир!");
        КонецПроцедуры
    "#;

    let tree = parser.parse(source, None).unwrap();
    println!("{}", tree.root_node().to_sexp());
}
```

### Node.js

Установите пакет:

```sh
npm install tree-sitter-hbk tree-sitter
```

```js
const Parser = require("tree-sitter");
const BSL = require("tree-sitter-hbk");

const parser = new Parser();
parser.setLanguage(BSL);

const sourceCode = `
Процедура Привет()
    Сообщить("Привет, мир!");
КонецПроцедуры
`;

const tree = parser.parse(sourceCode);
console.log(tree.rootNode.toString());
```

### Python

Установите пакет:

```sh
pip install tree-sitter-hbk tree-sitter
```

```python
import tree_sitter_hbk as tshbk
from tree_sitter import Language, Parser

BSL_LANGUAGE = Language(tshbk.language())
parser = Parser(BSL_LANGUAGE)

source = """
Процедура Привет()
    Сообщить("Привет, мир!");
КонецПроцедуры
""".encode()

tree = parser.parse(source)
print(tree.root_node.sexp())
```

### Грамматика запросов SDBL

Пакет также экспортирует самостоятельную грамматику языка запросов SDBL:

- Node.js: `require("tree-sitter-hbk").sdbl`;
- Rust: `tree_sitter_hbk::SDBL_LANGUAGE`;
- Python: `tree_sitter_hbk.SDBLLanguage()` или низкоуровневая капсула
  `tree_sitter_hbk.sdbl_language()`;
- Go: `tree_sitter_bsl.SDBLLanguage()` from the existing Go binding package;
- C: `tree_sitter_sdbl()` из `tree-sitter-bsl.h` и той же библиотеки.

Существующие точки входа BSL остаются языком пакета по умолчанию.

Пакет включает query-файлы tree-sitter для интеграций с редакторами:

- `grammars/bsl/queries/highlights.scm` для подсветки BSL;
- `grammars/bsl/queries/injections.scm` для внедрения статических строковых
  литералов BSL, начинающихся с ключевых слов SDBL-выражений, как `sdbl`;
- `grammars/sdbl/queries/highlights.scm` для подсветки самостоятельного SDBL и
  текста запросов, внедренного из BSL.

Для Zed используется локальное dev extension:
[`editors/zed-bsl`](editors/zed-bsl). Оно регистрирует BSL, SDBL и
специальную для Zed грамматику-носитель `sdbl_embedded`, чтобы исходный текст
внедренной BSL-строки подсвечивался без изменения контракта самостоятельной
грамматики `.sdbl`.

## Ссылки

- Грамматика основана на правилах [BSL Parser](https://github.com/1c-syntax/bsl-parser)
- Архитектурные решения: [`docs/decisions`](docs/decisions)
- Активный список parser-задач: [`spec/IMPLEMENTATION_TODO.md`](spec/IMPLEMENTATION_TODO.md)
- Контракт грамматики SDBL: [`spec/sdbl-query-language.md`](spec/sdbl-query-language.md)

[ci]: https://img.shields.io/github/actions/workflow/status/mussolene/tree-sitter-bsl/ci.yml?logo=github&label=CI
[npm]: https://img.shields.io/npm/v/tree-sitter-hbk?logo=npm
[crates]: https://img.shields.io/crates/v/tree-sitter-hbk?logo=rust
[pypi]: https://img.shields.io/pypi/v/tree-sitter-hbk?logo=python
