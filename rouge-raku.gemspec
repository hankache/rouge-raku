# frozen_string_literal: true

require './lib/rouge/raku/version'

Gem::Specification.new do |s|
  s.name = "rouge-raku"
  s.version = Rouge::Raku::VERSION
  s.authors = ["Naoum Hankache"]
  s.email = ["naoum88@gmail.com"]
  s.summary = "A Raku lexer for the Rouge syntax highlighter"
  s.description = <<-DESC.strip.gsub(/\s+/, ' ')
    Adds syntax highlighting for the Raku programming language
    to Rouge, as a plugin gem.
  DESC
  s.homepage = "https://github.com/hankache/rouge-raku"
  s.files = Dir['Gemfile', 'LICENSE', 'README.md', 'rouge-raku.gemspec', 'lib/**/*.rb', 'lib/rouge/demos/*']
  s.licenses = ['MIT']
  s.required_ruby_version = '>= 3.0'
  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/hankache/rouge-raku/issues",
    "source_code_uri"   => "https://github.com/hankache/rouge-raku",
    "rubygems_mfa_required" => "true"
  }

  s.add_dependency 'rouge', '~> 5.0'
end
