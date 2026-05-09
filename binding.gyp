{
  "targets": [
    {
      "target_name": "tree_sitter_bsl_binding",
      "dependencies": [
        "<!(node -p \"require('node-addon-api').targets\"):node_addon_api_except",
      ],
      "include_dirs": [
        "grammars/bsl/src",
        "grammars/sdbl/src",
      ],
      "sources": [
        "bindings/node/binding.cc",
        "grammars/bsl/src/parser.c",
        "grammars/sdbl/src/parser.c",
      ],
      "variables": {
        "has_scanner": "<!(node -p \"fs.existsSync('grammars/bsl/src/scanner.c')\")"
      },
      "conditions": [
        ["has_scanner=='true'", {
          "sources+": ["grammars/bsl/src/scanner.c"],
        }],
        ["OS!='win'", {
          "cflags_c": [
            "-std=c11",
          ],
        }, { # OS == "win"
          "cflags_c": [
            "/std:c11",
            "/utf-8",
          ],
        }],
      ],
    }
  ]
}
