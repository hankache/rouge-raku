# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Raku < RegexLexer
      title "Raku"
      desc "The Raku programming language (raku.org)"

      tag 'raku'

      filenames '*.raku', '*.rakumod', '*.rakutest', '*.rakudoc'
      mimetypes 'text/x-raku', 'application/x-raku'

      # Rouge resolves demos relative to its own lib directory, so point
      # at the copy shipped with this gem.
      demo_file File.join(__dir__, '..', 'demos', 'raku')

      def self.detect?(text)
        return true if text.shebang? 'raku'
      end

      state :root do
        rule %r/\s+/, Text
        rule %r/#.*$/, Comment::Single
        rule %r/[^\s#]+/, Text
      end
    end
  end
end
