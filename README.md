# rouge-raku

A [Raku](https://raku.org) lexer for the [Rouge](https://rouge.jneen.ca/)
syntax highlighter, packaged as a plugin gem. Rouge does not highlight Raku
on its own; with this gem loaded, it does.

## Installation

Add it to your `Gemfile`:

```ruby
gem 'rouge-raku'
```

or install it yourself:

```sh
gem install rouge-raku
```

## Usage

The gem has to be loaded for Rouge to know about Raku. How to do that
depends on what is running Rouge.

### Ruby

```ruby
require 'rouge'
require 'rouge-raku'

Rouge.highlight('say "Hello, World!";', 'raku', 'html')
```

### Command line

```sh
rougify highlight -r rouge-raku hello.raku
```

### Jekyll

Put the gem in the `jekyll_plugins` group of your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'rouge-raku'
end
```

or list it under `plugins` in `_config.yml`:

```yaml
plugins:
  - rouge-raku
```

Then use `raku` as the language of a code block:

````markdown
```raku
say "Hello, World!";
```
````

On GitHub Pages, the built-in build only loads GitHub's own list of plugins
and will not load this gem. Build the site with a GitHub Actions workflow
instead.

### Asciidoctor

Set Rouge as the highlighter in the document:

```asciidoc
:source-highlighter: rouge

[source,raku]
----
say "Hello, World!";
----
```

and load the gem when converting it:

```sh
asciidoctor -r rouge-raku document.adoc
```

## What it recognises

The lexer has the tag `raku`. Rouge picks it by itself for files ending in
`.raku`, `.rakumod`, `.rakutest` or `.rakudoc`, and for source that starts
with a `raku` or `rakudo` shebang or with `use v6`.

## Compatibility

Ruby 3.0 or later, and Rouge 3.26 or later, up to and including Rouge 5.

## Development

```sh
bundle install
bundle exec rake
```

To run the specs against another version of Rouge:

```sh
ROUGE_VERSION=4.7.0 bundle install
ROUGE_VERSION=4.7.0 bundle exec rake
```

The files in `spec/snippets/raku` each hold a piece of Raku and the tokens
it should produce, and the spec checks the lexer against them.

The layout follows Rouge's own conventions (`lib/rouge/lexers/raku.rb`,
`lib/rouge/demos/raku`, `spec/lexers/raku_spec.rb`,
`spec/visual/samples/raku`) so the lexer can be offered upstream later.

## License

[MIT](LICENSE)
