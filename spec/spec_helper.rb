# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'minitest/autorun'
require 'rouge-raku'

module Support
  module Lexing
    def assert_no_errors(text, lexer = subject)
      tokens = lexer.lex(text).to_a
      errors = tokens.select { |tok, _| tok == Rouge::Token::Tokens::Error }
      assert_empty errors, "lexing produced error tokens"
      assert_equal text, tokens.map(&:last).join, "lexing lost or changed input"
    end

    def assert_tokens_equal(text, *expected)
      actual = subject.lex(text).map { |tok, val| [tok.qualname, val] }
      assert_equal expected, actual
    end
  end

  # Reads the token snippets: files with a "---tokens---" section that
  # lists one token per line, as a quoted string followed by its type.
  module Snippets
    DIR = File.expand_path('snippets/raku', __dir__)

    ESCAPES = {
      'n' => "\n", 't' => "\t", 'r' => "\r", '\\' => '\\', "'" => "'", '"' => '"',
    }.freeze

    def self.names
      Dir.glob('*.txt', base: DIR).map { |f| File.basename(f, '.txt') }.sort
    end

    # @return [Array<Array(String, String)>] pairs of token type and value
    def self.tokens(name)
      lines = File.read(File.join(DIR, "#{name}.txt"), encoding: 'utf-8').lines
      lines = lines.drop_while { |l| l.chomp != '---tokens---' }.drop(1)
      lines.reject { |l| l.strip.empty? }.map do |line|
        literal, type = line.chomp.match(/\A(.*\S)\s+([A-Z][A-Za-z.]*)\z/m).captures
        [type, unquote(literal)]
      end
    end

    def self.unquote(literal)
      literal[1..-2].gsub(/\\(?:x(\h{2})|u(\h{4})|U(\h{8})|(.))/) do
        hex = $1 || $2 || $3
        hex ? [hex.hex].pack('U') : ESCAPES.fetch($4)
      end
    end

    # Joins neighbouring tokens of the same type, as Rouge does when lexing.
    def self.merge(tokens)
      tokens.each_with_object([]) do |(type, value), merged|
        if merged.last && merged.last[0] == type
          merged.last[1] += value
        else
          merged << [type, value.dup]
        end
      end
    end
  end
end
