# rouge-raku

A [Raku](https://raku.org) lexer for the [Rouge](https://github.com/rouge-ruby/rouge)
syntax highlighter, packaged as a plugin gem.

> **Status:** early development. The lexer is currently a stub that only
> recognises comments; it is not yet published to RubyGems.

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

## License

[MIT](LICENSE)
