#include <Python.h>

typedef struct TSLanguage TSLanguage;

const TSLanguage *tree_sitter_bsl(void);
const TSLanguage *tree_sitter_sdbl(void);

static PyObject* py_language(PyObject *self, PyObject *args) {
    return PyCapsule_New((void *)tree_sitter_bsl(), "tree_sitter.Language", NULL);
}

static PyObject* py_sdbl_language(PyObject *self, PyObject *args) {
    return PyCapsule_New((void *)tree_sitter_sdbl(), "tree_sitter.Language", NULL);
}

static PyMethodDef methods[] = {
    {"language", py_language, METH_NOARGS, "Get the tree-sitter language for BSL."},
    {"sdbl_language", py_sdbl_language, METH_NOARGS, "Get the tree-sitter language for SDBL."},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "_binding", NULL, -1, methods
};

PyMODINIT_FUNC PyInit__binding(void) {
    return PyModule_Create(&module);
}
