# Project Rules for Agents

These rules apply to the whole repository.

## Project Context

`tree-sitter-bsl` is a tree-sitter grammar for 1C BSL.

The repository owns grammar behavior and parser-facing contracts:

- `grammar.js` as the source grammar.
- `test/corpus/*.bsl` as the behavioral regression contract.
- `src/grammar.json`, `src/node-types.json`, `src/parser.c` and binding-facing
  generated artifacts when grammar generation is part of the change.
- Node, Rust and Python bindings only as parser package integration surfaces.

The repository does not own analyzer facts, diagnostics, metadata models, HBK
facts, query tools, report formats or downstream product behavior. Keep those
concerns out of grammar changes unless a later accepted project decision adds a
local contract for them.

Use `spec/IMPLEMENTATION_TODO.md` as the active parser-work ledger. `README.md`
is user-facing orientation and package usage documentation, not the
implementation ledger. When README, chat notes, comments or task text conflict
with the ledger, reconcile `spec/IMPLEMENTATION_TODO.md` before implementation.

## Implementation Order

For non-trivial grammar work, follow this order:

1. Read `spec/IMPLEMENTATION_TODO.md` and the relevant `grammar.js` rules.
2. Add or update focused corpus cases before changing grammar behavior.
3. Implement only the active syntax behavior and its direct verification.
4. Regenerate parser artifacts when the grammar changes.
5. Update `spec/IMPLEMENTATION_TODO.md`, README or release notes when the
   durable parser contract, validation command or public node shape changed.

Keep implementation small and grammar-specific. Do not introduce broad
compatibility layers, hidden fallbacks, generic parser pipelines or downstream
consumer adapters just to make a syntax case pass.

## Grammar Rules

Test and implement concrete BSL syntax behavior, not broad approximations.

- Prefer precise grammar rules over catch-all tokens.
- Do not accept invalid BSL only to avoid `ERROR` nodes.
- Keep structured preprocessor parsing for `#Если` / `#Область`; do not replace
  it with a generic skipped-line token.
- Use `lezer-bsl` snippets only as candidate input examples. Do not copy Lezer
  AST node names, visitors or failing expectations as the tree-sitter contract.
- Preserve existing node shapes where practical. If a node-shape migration is
  necessary, document it in tests and release notes.
- Keep unknown or intentionally unsupported syntax explicit in the ledger
  instead of hiding it in ad-hoc probes.

## Testing Rules

Test observable parser behavior.

- Corpus tests should describe the syntax contract being protected.
- Expected trees must use the current tree-sitter node style for this project.
- Do not test private helper order or incidental `grammar.js` decomposition.
- Prefer small corpus sections grouped by syntax feature over one large imported
  dump.
- Use deterministic BSL snippets for focused syntax coverage.
- Use real project files only as acceptance corpus inputs and never mutate those
  external checkouts during parser validation.

Normal validation:

- `npm test` verifies that the Node binding loads.
- `tree-sitter test` validates corpus expectations when the local CLI works.
- Targeted Node binding probes are acceptable only as temporary diagnostics when
  the tree-sitter CLI is blocked on the current host.

## Worktree Discipline

Generated artifacts, dependency directories and unrelated local changes may
exist in the checkout. Inspect scope before editing or committing, and do not
revert user-owned changes. Keep commits narrow: grammar changes, corpus changes,
generated parser updates and documentation updates should be grouped only when
they belong to the same parser behavior.
