# Zed BSL Dev Extension

This directory contains a local Zed language extension for checking the BSL
Tree-sitter grammar from this repository in Zed.

The extension is based on `dlyubanevich/zed-bsl-extension` at commit `b0975ec`,
but intentionally keeps only the grammar-facing files:

- `extension.toml`
- `languages/bsl/config.toml`
- `languages/bsl/highlights.scm`
- `languages/bsl/brackets.scm`

It does not register or download `bsl-language-server`; this repository owns
parser behavior, not downstream analyzer, LSP or region-folding behavior.

## Install In Zed

Run `zed: install dev extension` from the command palette and select this
directory:

```text
/home/alko/develop/open-source/tree-sitter-bsl/editors/zed-bsl
```

The grammar entry points at the local checkout via a `file://` URL and uses
`path = "grammars/bsl"` because the repository contains multiple grammars.

Before checking a grammar change in Zed:

1. Run `npm run generate:bsl` if `grammars/bsl/grammar.js` changed.
2. Commit the parser artifact revision you want Zed to fetch. Zed checks out
   the grammar through Git, so uncommitted grammar changes are not visible to
   the dev extension.
3. Update `[grammars.bsl].rev` in `extension.toml` when the grammar revision
   changes.
4. Reinstall or reload the dev extension in Zed.
