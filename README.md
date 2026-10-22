# KQL support for Zed

Syntax highlighting for Kusto Query Language (KQL), powered by
[kiennq/tree-sitter-kusto](https://github.com/kiennq/tree-sitter-kusto).

## What you get

- Highlighting for tabular operators, string operators, functions, types,
  literals, comments, and properties.
- Bracket matching, auto-indent, and an outline of `let` declarations.
- `.kql`, `.csl`, and `.kusto` files are recognized automatically.

## Install (dev extension)

1. In Zed, run `zed: install dev extension` from the command palette.
2. Select this `zed-kql` directory.
3. Open any `.kql` file. Zed builds the grammar on first install, which takes a
   moment.

If the file still opens as plain text, run `editor: language` and pick **KQL**.

## Layout

```
zed-kql/
  extension.toml            # extension metadata and grammar pin
  languages/kql/config.toml # file suffixes, comments, tab style
  languages/kql/highlights.scm
  languages/kql/brackets.scm
  languages/kql/indents.scm
  languages/kql/outline.scm
```

The grammar is pinned to a commit so builds are reproducible. Update `rev` in
`extension.toml` to pick up grammar fixes.

No Rust code is needed; this is a grammar-only extension.

## Notes

- The grammar covers query syntax; management commands are highlighted more
  coarsely.
- `mv-expand` with several `to typeof(...)` clauses is a known grammar gap and
  parses as an error region (highlighting of the rest of the file is unaffected).
