package org.treesitter

import org.junit.Test
import org.junit.Assert.*

class TreeSitterBslTest {

    @Test
    fun testCanLoadGrammar() {
        val language = TreeSitterBsl.getLanguage()
        assertNotNull(language)
    }
}
