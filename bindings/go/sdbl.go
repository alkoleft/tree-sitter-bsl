package tree_sitter_bsl

// #cgo CFLAGS: -std=c11 -fvisibility=hidden
// #include "../../grammars/sdbl/src/parser.c"
import "C"

import "unsafe"

func SDBLLanguage() unsafe.Pointer {
	return unsafe.Pointer(C.tree_sitter_sdbl())
}
