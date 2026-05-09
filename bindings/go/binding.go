package tree_sitter_bsl

// #cgo CFLAGS: -std=c11 -fvisibility=hidden
// #include "../../grammars/bsl/src/parser.c"
// #if __has_include("../../grammars/bsl/src/scanner.c")
// #include "../../grammars/bsl/src/scanner.c"
// #endif
import "C"

import "unsafe"

func Language() unsafe.Pointer {
	return unsafe.Pointer(C.tree_sitter_bsl())
}
