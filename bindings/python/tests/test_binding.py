import unittest
import tree_sitter
import tree_sitter_bsl


class TestLanguage(unittest.TestCase):
    def test_can_load_bsl_grammar(self):
        language = tree_sitter_bsl.Language()
        self.assertIsNotNone(language)
        parser = tree_sitter.Parser(language)
        self.assertIsNotNone(parser)
        tree = parser.parse("Процедура Проверка()\nКонецПроцедуры".encode())
        self.assertFalse(tree.root_node.has_error)

    def test_can_load_sdbl_grammar(self):
        language = tree_sitter_bsl.SDBLLanguage()
        self.assertIsNotNone(language)
        parser = tree_sitter.Parser(language)
        self.assertIsNotNone(parser)
        tree = parser.parse("ВЫБРАТЬ\n    *".encode())
        self.assertFalse(tree.root_node.has_error)


if __name__ == "__main__":
    unittest.main()
