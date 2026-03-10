#include <Python.h>

typedef struct TSLanguage TSLanguage;

const TSLanguage *tree_sitter_bsl(void);

static PyObject* py_language(PyObject *self, PyObject *args) {
    return PyCapsule_New((void *)tree_sitter_bsl(), "tree_sitter.Language", NULL);
}

static PyMethodDef methods[] = {
    {"language", py_language, METH_NOARGS, "Get the tree-sitter language for BSL."},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "_binding", NULL, -1, methods
};

PyMODINIT_FUNC PyInit__binding(void) {
    return PyModule_Create(&module);
}
