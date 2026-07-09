import tree_sitter
from ._binding import language, sdbl_language


def Language():
    """Return the tree-sitter Language for BSL."""
    return tree_sitter.Language(language())


def SDBLLanguage():
    """Return the tree-sitter Language for SDBL."""
    return tree_sitter.Language(sdbl_language())
