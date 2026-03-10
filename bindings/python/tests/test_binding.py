import unittest
import tree_sitter
import tree_sitter_bsl


class TestLanguage(unittest.TestCase):
    def test_can_load_grammar(self):
        language = tree_sitter_bsl.Language()
        self.assertIsNotNone(language)
        parser = tree_sitter.Parser(language)
        self.assertIsNotNone(parser)
        self.assertEqual(language.abi_version, tree_sitter.Language.abi_version)


if __name__ == "__main__":
    unittest.main()
