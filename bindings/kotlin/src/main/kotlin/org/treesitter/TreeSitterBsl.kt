package org.treesitter

class TreeSitterBsl {
    companion object {
        @JvmStatic
        external fun language(): Long

        @JvmStatic
        fun getLanguage(): TSLanguage = TSLanguage(language())

        init {
            System.loadLibrary("tree-sitter-bsl")
        }
    }
}
