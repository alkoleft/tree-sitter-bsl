## What's Changed

### Features
- Added Go, Python, Java, and Kotlin bindings (#5)

### Fixes
- Python: compatibility with `tree-sitter >= 0.25` — use `Parser(language)` constructor, return `PyCapsule`, wrap language capsule in `tree_sitter.Language`
- Kotlin: bump `jvmToolchain` to 22 for `jtreesitter` FFM compatibility
- Java/Kotlin: separate main and test sources into standard Gradle layout; add CMake native build integration
- CI: pin `node-version` to 22 to fix build on Node 24
- Updated `tree-sitter` to `^0.25.0` for compatibility with `tree-sitter-cli` 0.26.x

### CI
- Added PyPI and crates.io publishing
- Added `test-python`, `test-go` jobs; extended paths filter in lint
- Regenerated parser with `tree-sitter` v0.26.6

**Full Changelog**: https://github.com/alkoleft/tree-sitter-bsl/compare/v0.1.5...v0.1.6
