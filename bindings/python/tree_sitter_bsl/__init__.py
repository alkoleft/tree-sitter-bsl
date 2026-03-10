import tree_sitter
from ._binding import language


def Language():
    """Return the tree-sitter Language for BSL."""
    return tree_sitter.Language(language())
