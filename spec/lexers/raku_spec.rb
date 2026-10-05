# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'spec_helper'

describe Rouge::Lexers::Raku do
  include Support::Lexing

  let(:subject) { Rouge::Lexers::Raku.new }

  describe 'guessing' do
    it 'is found by tag' do
      assert_equal Rouge::Lexers::Raku, Rouge::Lexer.find('raku')
    end

    it 'guesses by filename' do
      %w(foo.raku Foo.rakumod foo.rakutest foo.rakudoc).each do |name|
        assert_equal Rouge::Lexers::Raku, Rouge::Lexer.guess(filename: name)
      end
    end

    it 'guesses by mimetype' do
      assert_equal Rouge::Lexers::Raku, Rouge::Lexer.guess(mimetype: 'text/x-raku')
    end

    it 'guesses by source' do
      ["#!/usr/bin/env raku\n", "#!/usr/bin/rakudo\n", "# a script\n\nuse v6.d;\n"].each do |source|
        assert_equal Rouge::Lexers::Raku, Rouge::Lexer.guess(source: source)
      end
    end

    it 'leaves Perl to the Perl lexer' do
      assert_equal Rouge::Lexers::Perl, Rouge::Lexer.guess(filename: 'foo.pm')
      assert_equal Rouge::Lexers::Perl, Rouge::Lexer.guess(source: "#!/usr/bin/perl\n")
    end
  end

  describe 'lexing' do
    it 'lexes line comments' do
      assert_tokens_equal "# hi\n",
        ['Comment.Single', '# hi'],
        ['Text.Whitespace', "\n"]
    end

    it 'nests the brackets of embedded comments' do
      assert_tokens_equal "#`[ a [b] c ] 1",
        ['Comment.Multiline', '#`[ a [b] c ]'],
        ['Text.Whitespace', ' '],
        ['Literal.Number.Integer', '1']
    end

    it 'runs an unclosed embedded comment to the end' do
      assert_tokens_equal "#`{{ a } b",
        ['Comment.Multiline', '#`{{ a } b']
    end

    it 'returns from a closure in a string' do
      assert_tokens_equal '"a{ {1} }b" 2',
        ['Literal.String.Double', '"a'],
        ['Punctuation', '{'],
        ['Text.Whitespace', ' '],
        ['Punctuation', '{'],
        ['Literal.Number.Integer', '1'],
        ['Punctuation', '}'],
        ['Text.Whitespace', ' '],
        ['Punctuation', '}'],
        ['Literal.String.Double', 'b"'],
        ['Text.Whitespace', ' '],
        ['Literal.Number.Integer', '2']
    end

    it 'lexes the demo without errors' do
      assert_no_errors Rouge::Lexers::Raku.demo
    end

    it 'lexes the visual sample without errors' do
      assert_no_errors File.read(File.expand_path('../visual/samples/raku', __dir__))
    end
  end

  describe 'snippets' do
    Support::Snippets.names.each do |name|
      it "lexes #{name}" do
        expected = Support::Snippets.merge(Support::Snippets.tokens(name))
        text = expected.map(&:last).join
        actual = subject.lex(text).map { |tok, val| [tok.qualname, val] }
        assert_equal expected, Support::Snippets.merge(actual)
      end
    end
  end
end
