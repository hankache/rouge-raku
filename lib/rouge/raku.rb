# frozen_string_literal: true

require 'rouge'

require_relative 'raku/version'
require_relative 'lexers/raku'

module Rouge
  module Lexers
    class Raku
      # Rouge looks for the demo of a lexer among its own files. This one
      # ships with this gem.
      def self.demo_file(*)
        Pathname.new(File.join(__dir__, 'demos', 'raku'))
      end

      # The lexer looks behind the text it is matching ("not after a dot"),
      # which only works if the scanner anchors on the whole input and not
      # on the place it has reached. Rouge sets its scanner up that way from
      # version 5.0 on. Do the same for the versions before it.
      if Gem::Version.new(Rouge.version) < Gem::Version.new('5.0')
        def stream_tokens(str, &b)
          stream = StringScanner.new(str, fixed_anchor: true)

          @current_stream = stream
          @output_stream  = b
          @states         = self.class.states
          @null_steps     = 0

          until stream.eos?
            b.call(Token::Tokens::Error, stream.getch) unless step(state, stream)
          end
        end
      end
    end
  end
end
