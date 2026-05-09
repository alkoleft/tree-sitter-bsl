# Zed BSL Dev Extension

This directory contains a local Zed language extension for checking the BSL
Tree-sitter grammar from this repository in Zed.

The extension is based on `dlyubanevich/zed-bsl-extension` at commit `b0975ec`,
but intentionally keeps only the grammar-facing files:

- `extension.toml`
- `languages/bsl/config.toml`
- `languages/bsl/highlights.scm`
- `languages/bsl/injections.scm`
- `languages/bsl/brackets.scm`
- `languages/sdbl/config.toml`
- `languages/sdbl/highlights.scm`
- `languages/sdbl-embedded/config.toml`
- `languages/sdbl-embedded/highlights.scm`
- `grammars/sdbl-embedded/grammar.js`

It does not register or download `bsl-language-server`; this repository owns
parser behavior, not downstream analyzer, LSP or region-folding behavior.

## Install In Zed

Run `zed: install dev extension` from the command palette and select this
directory:

```text
/home/alko/develop/open-source/tree-sitter-bsl/editors/zed-bsl
```

The grammar entries point at the local checkout via `file://` URLs and use
explicit `path` values because the repository contains separate `bsl` and
`sdbl` grammars.

Static BSL string literals that start with `ВЫБРАТЬ`, `SELECT`, `УНИЧТОЖИТЬ` or
`DROP` are injected through the `sdbl_embedded` editor grammar. It inherits the
standalone SDBL grammar but accepts the raw BSL string carrier (`"` and `|`
continuation markers), so Zed can parse the actual injected source without
weakening standalone `.sdbl` parsing or changing the BSL parse tree.

Before checking a grammar change in Zed:

1. Run `npm run generate:bsl` if `grammars/bsl/grammar.js` changed.
2. Run `npm run generate:sdbl` if `grammars/sdbl/grammar.js` changed.
3. Commit the parser artifact revision you want Zed to fetch. Zed checks out
   grammars through Git, so uncommitted grammar changes are not visible to the
   dev extension.
4. Update the relevant `[grammars.*].rev` in `extension.toml` when the grammar
   revision changes.
5. Reinstall or reload the dev extension in Zed.
