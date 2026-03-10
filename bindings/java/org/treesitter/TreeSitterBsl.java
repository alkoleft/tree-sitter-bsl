package org.treesitter;

import org.treesitter.TSLanguage;

public class TreeSitterBsl {

    private static native long language();

    public static TSLanguage getLanguage() {
        return new TSLanguage(language());
    }

    static {
        System.loadLibrary("tree-sitter-bsl");
    }
}
