package org.treesitter;

import org.junit.Test;
import static org.junit.Assert.*;

public class TreeSitterBslTest {

    @Test
    public void testCanLoadGrammar() {
        TSLanguage language = TreeSitterBsl.getLanguage();
        assertNotNull(language);
    }
}
