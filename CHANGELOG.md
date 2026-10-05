# Changelog

## 0.1.0

First release.

- A lexer for Raku: comments, Pod, variables, numbers, keywords, types,
  operators, strings and quote-like forms, heredocs, regexes, substitutions
  and grammars.
- Registers the tag `raku` and the file extensions `.raku`, `.rakumod`,
  `.rakutest` and `.rakudoc`, and recognises Raku source by a `raku` or
  `rakudo` shebang or a leading `use v6`.
- Works with Rouge 3.26 and later, up to and including Rouge 5.
