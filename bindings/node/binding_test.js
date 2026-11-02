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

test("BSL: CR-only module with // comment keeps code after the comment", () => {
  const parser = new Parser();
  const BSL = require(".");
  parser.setLanguage(BSL);

  const tree = parser.parse(
    "Процедура П()\r\tА = 1;\r\t// контроль\r\tБ = 2;\rКонецПроцедуры",
  );
  assert.equal(tree.rootNode.hasError, false);

  const types = [];
  (function walk(node) {
    types.push(node.type);
    for (let i = 0; i < node.childCount; i++) walk(node.child(i));
  })(tree.rootNode);
  const comments = types.filter((t) => t === "line_comment").length;
  const assignments = types.filter((t) => t === "assignment_statement").length;
  assert.ok(comments >= 1, "expected a line_comment in the tree");
  assert.equal(assignments, 2, "code after the CR-terminated comment must survive");
});

test("BSL: line_comment does not own the CR line terminator", () => {
  const parser = new Parser();
  const BSL = require(".");
  parser.setLanguage(BSL);

  const source = "// комм\r\nА = 1;";
  const tree = parser.parse(source);
  const comment = tree.rootNode.namedChild(0);
  assert.equal(comment.type, "line_comment");
  assert.equal(
    source.slice(comment.startIndex, comment.endIndex),
    "// комм",
    "node must end right after the comment body, without \\r",
  );
});

test("BSL: // at CR-only file start does not swallow the module (issue #19)", () => {
  const parser = new Parser();
  const BSL = require(".");
  parser.setLanguage(BSL);

  const tree = parser.parse("// шапка\rА = 1;");
  assert.equal(tree.rootNode.hasError, false);
  assert.equal(tree.rootNode.namedChildCount, 2);
  assert.equal(tree.rootNode.namedChild(0).type, "line_comment");
  assert.equal(tree.rootNode.namedChild(1).type, "assignment_statement");
});

test("SDBL: CR-only query with // comment parses without errors", () => {
  const parser = new Parser();
  const { sdbl } = require(".");
  parser.setLanguage(sdbl);

  const tree = parser.parse(
    'ВЫБРАТЬ\r    Т.Ссылка КАК Товар\rИЗ\r    Справочник.Номенклатура КАК Т\r// остатки\rГДЕ\r    Т.Код = "1"',
  );
  assert.equal(tree.rootNode.hasError, false);
});
