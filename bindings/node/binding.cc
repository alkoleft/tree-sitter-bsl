#include <napi.h>

typedef struct TSLanguage TSLanguage;

extern "C" TSLanguage *tree_sitter_bsl();
extern "C" TSLanguage *tree_sitter_sdbl();

// "tree-sitter", "language" hashed with BLAKE2
const napi_type_tag LANGUAGE_TYPE_TAG = {
    0x8AF2E5212AD58ABF, 0xD5006CAD83ABBA16
};

Napi::External<TSLanguage> CreateLanguage(Napi::Env env, TSLanguage *language_fn()) {
    auto language = Napi::External<TSLanguage>::New(env, language_fn());
    language.TypeTag(&LANGUAGE_TYPE_TAG);
    return language;
}

Napi::Object CreateLanguageObject(Napi::Env env, TSLanguage *language_fn()) {
    auto language = CreateLanguage(env, language_fn);
    auto object = Napi::Object::New(env);
    object["language"] = language;
    return object;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    auto language = CreateLanguage(env, tree_sitter_bsl);
    exports["language"] = language;
    exports["sdbl"] = CreateLanguageObject(env, tree_sitter_sdbl);
    return exports;
}

NODE_API_MODULE(tree_sitter_bsl_binding, Init)
