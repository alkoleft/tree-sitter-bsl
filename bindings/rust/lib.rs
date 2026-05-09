//! This crate provides BSL language support for the [tree-sitter][] parsing library.
//!
//! Typically, you will use the [LANGUAGE][] constant to add this language to a
//! tree-sitter [Parser][], and then use the parser to parse some code:
//!
//! ```
//! let code = r#"
//! "#;
//! let mut parser = tree_sitter::Parser::new();
//! let language = tree_sitter_bsl::LANGUAGE;
//! parser
//!     .set_language(&language.into())
//!     .expect("Error loading BSL parser");
//! let tree = parser.parse(code, None).unwrap();
//! assert!(!tree.root_node().has_error());
//! ```
//!
//! [Parser]: https://docs.rs/tree-sitter/*/tree_sitter/struct.Parser.html
//! [tree-sitter]: https://tree-sitter.github.io/

use tree_sitter_language::LanguageFn;

extern "C" {
    fn tree_sitter_bsl() -> *const ();
    fn tree_sitter_sdbl() -> *const ();
}

/// The tree-sitter [`LanguageFn`][LanguageFn] for this grammar.
///
/// [LanguageFn]: https://docs.rs/tree-sitter-language/*/tree_sitter_language/struct.LanguageFn.html
pub const LANGUAGE: LanguageFn = unsafe { LanguageFn::from_raw(tree_sitter_bsl) };

/// The tree-sitter [`LanguageFn`][LanguageFn] for the standalone SDBL query grammar.
pub const SDBL_LANGUAGE: LanguageFn = unsafe { LanguageFn::from_raw(tree_sitter_sdbl) };

/// The content of the [`node-types.json`][] file for this grammar.
///
/// [`node-types.json`]: https://tree-sitter.github.io/tree-sitter/using-parsers/6-static-node-types
pub const NODE_TYPES: &str = include_str!("../../grammars/bsl/src/node-types.json");

/// The content of the SDBL [`node-types.json`][] file.
pub const SDBL_NODE_TYPES: &str = include_str!("../../grammars/sdbl/src/node-types.json");

// NOTE: uncomment these to include any queries that this grammar contains:

// pub const HIGHLIGHTS_QUERY: &str = include_str!("../../grammars/bsl/queries/highlights.scm");
// pub const INJECTIONS_QUERY: &str = include_str!("../../grammars/bsl/queries/injections.scm");
// pub const LOCALS_QUERY: &str = include_str!("../../grammars/bsl/queries/locals.scm");
// pub const TAGS_QUERY: &str = include_str!("../../grammars/bsl/queries/tags.scm");

#[cfg(test)]
mod tests {
    #[test]
    fn test_can_load_bsl_grammar() {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&super::LANGUAGE.into())
            .expect("Error loading BSL parser");

        let tree = parser
            .parse("Процедура Проверка()\nКонецПроцедуры", None)
            .unwrap();
        assert!(!tree.root_node().has_error());
    }

    #[test]
    fn test_can_load_sdbl_grammar() {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&super::SDBL_LANGUAGE.into())
            .expect("Error loading SDBL parser");

        let tree = parser.parse("ВЫБРАТЬ\n    *", None).unwrap();
        assert!(!tree.root_node().has_error());
    }
}
