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
      assert_equal Rouge::Lexers::Raku, Rouge::Lexer.guess(source: "#!/usr/bin/env raku\n")
    end

    it 'leaves Perl files to the Perl lexer' do
      assert_equal Rouge::Lexers::Perl, Rouge::Lexer.guess(filename: 'foo.pm')
    end
  end

  describe 'lexing' do
    it 'lexes line comments' do
      assert_tokens_equal "# hi\n",
        ['Comment.Single', '# hi'],
        ['Text', "\n"]
    end

    it 'lexes the demo without errors' do
      assert_no_errors Rouge::Lexers::Raku.demo
    end

    it 'lexes the visual sample without errors' do
      assert_no_errors File.read(File.expand_path('../visual/samples/raku', __dir__))
    end
  end
end
