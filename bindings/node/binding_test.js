const assert = require("node:assert");
const { test } = require("node:test");

const Parser = require("tree-sitter");

test("can load BSL grammar", () => {
  const parser = new Parser();
  const BSL = require(".");
  assert.doesNotThrow(() => parser.setLanguage(BSL));

  const tree = parser.parse("Процедура Проверка()\nКонецПроцедуры");
  assert.equal(tree.rootNode.hasError, false);
});

test("can load SDBL grammar", () => {
  const parser = new Parser();
  const { sdbl } = require(".");
  assert.ok(sdbl);
  assert.doesNotThrow(() => parser.setLanguage(sdbl));

  const tree = parser.parse("ВЫБРАТЬ\n    *");
  assert.equal(tree.rootNode.hasError, false);
});
