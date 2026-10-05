# rouge-raku

A [Raku](https://raku.org) lexer for the [Rouge](https://github.com/rouge-ruby/rouge)
syntax highlighter, packaged as a plugin gem.

> **Status:** early development, not yet published to RubyGems. Most of
> the language is highlighted: comments, variables, numbers, keywords,
> types, operators, strings, quote-like forms (`q`, `qq`, `Q`) and
> heredocs. Regexes and grammars, and Pod, are not handled yet.

## Usage

Add the gem to your `Gemfile`, pointing at this repository:

```ruby
gem 'rouge-raku', github: 'hankache/rouge-raku'
```

Then require it after Rouge:

```ruby
require 'rouge'
require 'rouge-raku'

Rouge.highlight('say "Hello, World!";', 'raku', 'html')
```

The lexer registers the tag `raku` and the file extensions `.raku`,
`.rakumod`, `.rakutest` and `.rakudoc`.

## Development

```sh
bundle install
bundle exec rake
```

The layout follows Rouge's own conventions (`lib/rouge/lexers/raku.rb`,
`lib/rouge/demos/raku`, `spec/lexers/raku_spec.rb`,
`spec/visual/samples/raku`) so the lexer can be offered upstream later.

The files in `spec/snippets/raku` each hold a piece of Raku and the tokens
it should produce, and the spec checks the lexer against them.

## License

[MIT](LICENSE)
