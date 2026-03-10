import unittest
import tree_sitter_bsl


class TestLanguage(unittest.TestCase):
    def test_can_load_grammar(self):
        language = tree_sitter_bsl.Language()
        self.assertIsNotNone(language)


if __name__ == "__main__":
    unittest.main()
