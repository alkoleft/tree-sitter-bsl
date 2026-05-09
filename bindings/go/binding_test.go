package tree_sitter_bsl_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_bsl "github.com/tree-sitter/tree-sitter-bsl/bindings/go"
)

func TestCanLoadBSLGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_bsl.Language())
	if language == nil {
		t.Errorf("Error loading BSL grammar")
	}

	parser := tree_sitter.NewParser()
	parser.SetLanguage(language)
	tree := parser.Parse([]byte("Процедура Проверка()\nКонецПроцедуры"), nil)
	if tree.RootNode().HasError() {
		t.Errorf("Error parsing BSL source")
	}
}

func TestCanLoadSDBLGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_bsl.SDBLLanguage())
	if language == nil {
		t.Errorf("Error loading SDBL grammar")
	}

	parser := tree_sitter.NewParser()
	parser.SetLanguage(language)
	tree := parser.Parse([]byte("ВЫБРАТЬ\n    *"), nil)
	if tree.RootNode().HasError() {
		t.Errorf("Error parsing SDBL source")
	}
}
