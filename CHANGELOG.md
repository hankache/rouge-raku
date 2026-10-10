# Changelog

## 0.2.0

- Quotes: `q.new` and `q'x` are names, `q(1)`, `m(1)` and `s(1)` are calls,
  and `s[0]` is an index, none of them the start of a quote or a regex. A
  quote interpolates what its adverbs say (`q:s`, `Qc`, `qq:!s`), `qww` and
  `qqww` are quotes, and `:heredoc` opens a heredoc like `:to`.
- Strings interpolate calls and chains of method calls that end in
  parentheses (`"$f()"`, `"$obj.name.uc()"`, `"@a>>.gist()"`) and subscripts
  after a dot (`"@a.[0]"`).
- Regexes: recognised after `where`, `handles`, `...` and a flip-flop, and
  across lines after a smartmatch. The arguments of a rule and of an adverb
  are code (`<expr(3)>`, `m:nth(2)/x/`). `S!~~` and the other sequential
  operators are not substitutions, and `[/]` is not a regex.
- Word lists: after a prefix operator (`~<a b c>`), after `enum`, as the
  value of a colon-pair (`:name«$x»`), with an escaped `\>` in them, and
  with `#` starting a comment in the interpolating forms.
- Numbers: `⅒`, `½` and `Ⅷ`, more forms in angle brackets (`<0x01/0x02>`,
  `<NaN+0i>`), versions that end in a word (`v6.e.PREVIEW`), and no number
  in `foo().5`.
- Names: extended identifiers are one variable (`$foo:bar<baz>`), `Z=>` is
  the zip operator, a word after a minus sign keeps its meaning (`-Inf`),
  `%` and `&` in front of a digit are operators (`$x%%3`), operator names
  can be in double angle brackets, and the label after `next`, `last` and
  `redo` is a label. A subscript in angle brackets is a string, not a part
  of the variable (`%h<key>`).
- Hyper operators around a Unicode operator (`»⋅«`), and a hyper prefix in
  front of a word list.
- Lists: the native types of NativeCall, the documented methods of the
  metamodel, three more traits, the phasers that can follow `will`, and the
  values of the enumerations that come with the language (`Less`, `Empty`,
  `SIGINT`, ...).
- The `#!` line that starts a script is a hashbang comment.
- Pod: code blocks are lexed as Raku unless they name another language
  (`:lang<shell>`), and the other verbatim blocks are plain text.
  Formatting codes can use `<< >>` and `« »`, nest and span lines. The
  options of a directive are lexed as pairs, and the name of a block is
  part of its directive (`=begin comment`). Pod can be indented, and can
  end with the file.

## 0.1.0

First release.

- A lexer for Raku: comments, Pod, variables, numbers, keywords, types,
  operators, strings and quote-like forms, heredocs, regexes, substitutions
  and grammars.
- Registers the tag `raku` and the file extensions `.raku`, `.rakumod`,
  `.rakutest` and `.rakudoc`, and recognises Raku source by a `raku` or
  `rakudo` shebang or a leading `use v6`.
- Works with Rouge 3.26 and later, up to and including Rouge 5.
