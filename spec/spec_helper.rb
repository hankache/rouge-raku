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
end
