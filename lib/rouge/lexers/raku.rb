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
        return true if text.shebang?(/raku|rakudo/)
        return true if text =~ /\A(?:\s*(?:#.*)?\n)*\s*use\s+v6\b/
      end

      # words that declare something: scope, routine and package declarators
      DECLARATORS = %w(
        anon augment class constant enum grammar has knowhow macro
        method module multi my only our package proto regex role rule
        state sub submethod subset supersede token unit
      ).freeze

      NAMESPACE_KEYWORDS = %w(
        import need no require use
      ).freeze

      # phasers, control flow, traits and other reserved words
      KEYWORDS = %w(
        BEGIN CATCH CHECK CLOSE CONTROL DOC END ENTER FIRST INIT KEEP
        LAST LEAVE NEXT POST PRE QUIT UNDO also default do does eager
        else elsif export for gather given handles hides hyper if is
        last lazy let loop made make native next of once orwith
        proceed quietly race react redo repeat repr required return
        return-rw returns rw sink start succeed supply symbol temp
        trusts try unless until when whenever where while will with
        without
      ).freeze

      # names of the traits that can follow "is"
      TRAITS = %w(
        DEPRECATED assoc built cached copy default dynamic equiv
        export hidden-from-USAGE hidden-from-backtrace
        implementation-detail looser native nodal pure raw readonly
        repr required rw symbol test-assertion tighter
      ).freeze

      # Routines that can be called as a plain word: say "hi", map(...). These
      # are builtins wherever they appear. Routines of the Test module are
      # included, as a lexer cannot know whether it has been loaded.
      BUILTINS = %w(
        abs acos acosec acosech acosh acotan acotanh all any append
        asec asech asin asinh atan atan2 atanh atomic-assign
        atomic-dec-fetch atomic-fetch atomic-fetch-add
        atomic-fetch-dec atomic-fetch-inc atomic-fetch-sub
        atomic-inc-fetch await bag bail-out callframe callsame
        callwith can-ok cas categorize ceiling cglobal chars chdir
        chmod chomp chop chown chr chrs cis classify close cmp-ok comb
        combinations copy cos cosec cosech cosh cotan cotanh cross dd
        deepmap defined diag die dies-ok dir does-ok done done-testing
        duckmap elems emit end EVAL eval-dies-ok eval-lives-ok
        EVALFILE exit exits-ok exp explicitly-manage expmod fail
        fails-like fc first flat flip floor flunk full-barrier get
        getc gist grep hash head index indir is-approx is-deeply
        is-prime isa-ok isnt item join keys kv lastcall lc like lines
        link list lives-ok log log10 log2 lsb MAIN map max min minmax
        mix mkdir move msb nano nativecast nativesizeof nextcallee
        nextsame nextwith nodemap nok none not note now ok one open
        ord ords pack pairs parse-base parse-names pass periods
        permutations pick plan pop prepend print printf produce prompt
        push put rand reduce rename repeated repl report reverse
        rindex rmdir roll roots rotate round roundrobin run samecase
        samemark samewith say sec sech set shell shift sign signal sin
        sinh skip skip-rest sleep sleep-timer sleep-until slip slurp
        snap snapper snip snitch so sort splice split sprintf spurt
        sqrt squish srand subbuf-rw substr substr-rw subtest sum
        symlink tail take take-rw tan tanh tc tclc throws-like time
        todo trim trim-leading trim-trailing truncate uc undefine
        unimatch uniname uninames uniparse uniprop uniprops unique
        unival unlike unlink unpack unpolar unshift USAGE use-ok val
        values warn wordcase words zip
      ).freeze

      # Routines that only exist as methods. "name" is the builtin in
      # "$x.name", but on its own it is a word the user chose ("name => 1",
      # "sub name"), so these are only builtins after a dot.
      METHODS = %w(
        abs2rel absolute accept ACCEPTS accessed acquire act action
        actions add add_attribute add_enum_value add_fallback
        add_method add_parent add_private_method add_role add_trustee
        adverb after allocate allof alternative-names annotations
        antipair antipairs anyof app_lifetime arch archname are args
        arity ASSIGN-KEY ASSIGN-POS assuming ast at AT-KEY AT-POS
        attributes auth backtrace base base-repeating basename batch
        before BIND-KEY BIND-POS bind-stderr bind-stdin bind-stdout
        bind-udp bits bless block bool-only bounds break Bridge broken
        BUILD build-date bytecode-size bytes cache CALL-ME
        calling-package can cancel candidates cando canonpath caps
        caption capture catdir categorize-list catfile catpath cause
        changed child child-name child-typename chunks classify-list
        cleanup clone close-stdin closed code codes collate column
        command comment compiler compose compose_type composer concise
        condition config configure_destroy configure_type_checking
        conj connect constraints construct contains contents count
        count-only cpu-cores cpu-usage CREATE create_type created cue
        curdir curupdir d day day-fraction day-of-month day-of-week
        day-of-year daycount days-in-month days-in-year dd-mm-yyyy
        declaration decode decoder default DEFINITE delayed DELETE-KEY
        DELETE-POS denominator desc DESTROY destroyers dev devnull
        devtype did-you-mean dir-sep dir-with-entries dirname
        DISTROnames do does dynamic e eager earlier enclosing encode
        encoder encoding ends-with enum_from_value enum_value_list
        enum_values enums eof err exception excludes-max excludes-min
        EXISTS-KEY EXISTS-POS exitcode expected extension f feature
        file filename find_method find_method_qualified finish
        first-date-in-month flatmap flush fmt format formatter freeze
        from from-list from-loop from-posix from-slurpy full get_value
        got grab grabpairs handle handled handles hardware
        has_accessor headers hh-mm-ss hidden hides hour HOW how hyper
        id illegal im in in-range in-timezone indent indices infinite
        infix inode install_method_cache instead int-bounds interval
        invalid-str invert invocant is-absolute is-hidden
        is-implementation-detail is-initial-thread is-int is-lazy
        is-leap-year is-relative is-routine is-setting is-win
        is_trusted is_type isa isNaN iterator julian-date keep kept
        KERNELnames key keyof kill kxxv l lang last last-date-in-month
        later lazy leading level line listen live local lock lookup
        made make match maxpairs merge message method method_table
        methods migrate minpairs minus minute misplaced mm-dd-yyyy
        mode modified modified-julian-date modifier month mro multi
        multi-invocant multiness my name named named_names narrow
        native-descriptor new new-from-daycount new-from-pairs
        new_type next next-handle next-interesting-index nice nl-in
        nl-out norm nude numerator of offset offset-in-hours
        offset-in-minutes old on-close on-switch opened operation
        optional orig os-error osname out out-buffer outer
        outer-caller-idx package package-kind package-name packages
        pair pairup parameter params parent parent-name parents parse
        parsefile parts path path-sep payload peer-host peer-port perl
        phaser pickpairs pid placeholder plus polar poll polymod port
        pos positional posix postfix postmatch precomp-ext
        precomp-target pred prefix prematch print-nl print-to private
        private_method_table proc protect pull-one push-all
        push-at-least push-exactly push-until-lazy qualifier-type quit
        r race radix raku range raw re read readchars readonly ready
        reallocate reals reason rebless receive recv redispatcher redo
        rel2abs relative release remove replace-with replacement REPR
        reserved resolve restore result resume rethrow returns right
        role roles_to_compose rolish rootdir rotor routine-type rw rwx
        s schedule-on scheduler scope second seek send serial
        set-instruments set_hidden set_name set_package set_rw
        set_value setup_finalization shape share sibling sigil signals
        signature sink sink-all skip-at-least skip-at-least-pull-one
        skip-one slice slurp-rest slurpy socket-host socket-port
        source source-package spawn SPEC splitdir splitpath stable
        start started starts-with status stderr stdout sub_signature
        subbuf subname subparse subst subst-mutate substr-eq succ
        suffix summary t tap target target-name tell then throttle
        throw timezone tmpdir to to-posix today toggle total trailing
        trans tree truncated-to trusts try_acquire trying twigil type
        type_captures typename udp uncaught_handler univals unlock
        unset unwrap updir usage-name utc value VAR variable
        verbose-config version VMnames volume vow w wait watch
        watch-path week week-number week-year weekday-of-month WHAT
        when WHERE WHEREFORE WHICH WHO whole-second WHY workaround
        wrap write write-to x yada year yield yyyy-mm-dd z zip-latest
      ).freeze

      BUILTIN_CLASSES = %w(
        Any Array Associative AST atomicint Attribute Backtrace
        Backtrace::Frame Bag Baggy BagHash Blob Block Bool Buf
        Callable CallFrame Cancellation Capture CArray Channel Code
        Complex ComplexStr Cool CurrentThreadScheduler Date Dateish
        DateTime Distro Duration Encoding Exception Failure FatRat
        Grammar Hash HyperWhatever Instant Int int16 int32 int64 int8
        IntStr IO IO::ArgFiles IO::CatHandle IO::Handle
        IO::Notification IO::Path IO::Path::Cygwin IO::Path::QNX
        IO::Path::Unix IO::Path::Win32 IO::Pipe IO::Socket
        IO::Socket::Async IO::Socket::INET IO::Spec IO::Spec::Cygwin
        IO::Spec::QNX IO::Spec::Unix IO::Spec::Win32 IO::Special
        Iterable Iterator Junction Kernel Label List Lock Lock::Async
        long longlong Macro Map Match Metamodel::AttributeContainer
        Metamodel::C3MRO Metamodel::ClassHOW Metamodel::EnumHOW
        Metamodel::Finalization Metamodel::MethodContainer
        Metamodel::MROBasedMethodDispatch
        Metamodel::MultipleInheritance Metamodel::Naming
        Metamodel::Primitives Metamodel::PrivateMethodContainer
        Metamodel::RoleContainer Metamodel::Trusting Method Mix
        MixHash Mixy Mu NFC NFD NFKC NFKD Num num32 num64 Numeric
        NumStr ObjAt Order Pair Parameter Perl Pod::Block
        Pod::Block::Code Pod::Block::Comment Pod::Block::Declarator
        Pod::Block::Named Pod::Block::Para Pod::Block::Table
        Pod::Heading Pod::Item Pointer Positional
        PositionalBindFailover Proc Proc::Async Promise Proxy
        PseudoStash QuantHash Range Rat Rational RatStr Real Regex
        Routine Scalar Scheduler Semaphore Seq Set SetHash Setty
        Signature size_t Slip Stash Str StrDistance Stringy Sub
        Submethod Supplier Supplier::Preserving Supply Systemic Tap
        Telemetry Telemetry::Instrument::Thread
        Telemetry::Instrument::Usage Telemetry::Period
        Telemetry::Sampler Thread ThreadPoolScheduler UInt uint16
        uint32 uint64 uint8 Uni utf8 Variable Version VM Whatever
        WhateverCode Allomorph Collation CompUnit
        CompUnit::PrecompilationRepository CompUnit::Repository
        CompUnit::Repository::FileSystem
        CompUnit::Repository::Installation
        CompUnit::Repository::Unknown Compiler Distribution
        Distribution::Hash Distribution::Locally Distribution::Path
        Distribution::Resource Encoding::Registry Endian Enumeration
        ForeignCode Format Formatter HyperSeq IO::Notification::Change
        IO::Path::Parts IO::Socket::Async::ListenSocket
        IterationBuffer Lock::ConditionVariable
        Metamodel::ConcreteRoleHOW Metamodel::CurriedRoleHOW
        Metamodel::DefiniteHOW Metamodel::Documenting
        Metamodel::MethodDelegation Metamodel::Mixins
        Metamodel::PackageHOW Metamodel::ParametricRoleGroupHOW
        Metamodel::ParametricRoleHOW Metamodel::RolePunning
        Metamodel::Stashing Metamodel::TypePretense
        Metamodel::Versioning Pod::Defn Pod::FormattingCode
        PredictiveIterator PromiseStatus RaceSeq Raku RakuAST
        Routine::WrapHandle Sequence Signal
        Telemetry::Instrument::ThreadPool Unicode ValueObjAt array
        blob8 blob16 blob32 blob64 buf8 buf16 buf32 buf64 byte int num
        str uint
      ).freeze

      WORD_OPERATORS = %w(
        after and andthen before but cmp coll div eq eqv ff fff gcd ge
        gt lcm le leg lt max min minmax mod ne not notandthen or
        orelse R so unicmp x X xor xx Z
      ).freeze

      CONSTANTS = %w(
        π τ ∞ 𝑒 pi tau Inf NaN e i
      ).freeze

      # Symbolic operators, including the Unicode synonyms. They are sorted
      # longest-first when the regex is built so that e.g. "==>" wins over "==".
      SYMBOL_OPERATORS = %w(
        ... … <=> ==>> <<== ==> <== === =:= =~= !~~ ~~ ::= := ^..^ ..^
        ^.. .. ** ++ -- && || // ^^ ?? !! == != <= >= => %% +& +| +^
        +< +> ~& ~| ~^ ~< ~> ?& ?| ?^ --> <-> -> ! ? + - * / % ~ | & ^
        < > = . ∈ ∉ ∋ ∌ ⊂ ⊄ ⊃ ⊅ ⊆ ⊈ ⊇ ⊉ ≼ ≽ ∪ ∩ ∖ ⊖ ⊍ ⊎ ≤ ≥ ≠ ≅ × ÷ −
        ∘ ⚛ ≡ ≢ ⩶ ⩵ ∊ ∍
      ).freeze

      # Raku has a *lot* of possible bracketing characters. This list was
      # lifted from STD.pm6 (https://github.com/perl6/std).
      BRACKETS = %w(
        () <> [] {} «» ༺༻ ༼༽ ᚛᚜ ‘’ ‚’ ‛’ “” „” ‟” ‹› ⁅⁆ ⁽⁾ ₍₎ ∈∋ ∉∌ ∊∍
        ∕⧵ ∼∽ ≃⋍ ≒≓ ≔≕ ≤≥ ≦≧ ≨≩ ≪≫ ≮≯ ≰≱ ≲≳ ≴≵ ≶≷ ≸≹ ≺≻ ≼≽ ≾≿ ⊀⊁ ⊂⊃ ⊄⊅
        ⊆⊇ ⊈⊉ ⊊⊋ ⊏⊐ ⊑⊒ ⊘⦸ ⊢⊣ ⊦⫞ ⊨⫤ ⊩⫣ ⊫⫥ ⊰⊱ ⊲⊳ ⊴⊵ ⊶⊷ ⋉⋊ ⋋⋌ ⋐⋑ ⋖⋗ ⋘⋙ ⋚⋛
        ⋜⋝ ⋞⋟ ⋠⋡ ⋢⋣ ⋤⋥ ⋦⋧ ⋨⋩ ⋪⋫ ⋬⋭ ⋰⋱ ⋲⋺ ⋳⋻ ⋴⋼ ⋶⋽ ⋷⋾ ⌈⌉ ⌊⌋ 〈〉 ⎴⎵ ❨❩ ❪❫
        ❬❭ ❮❯ ❰❱ ❲❳ ❴❵ ⟃⟄ ⟅⟆ ⟕⟖ ⟝⟞ ⟢⟣ ⟤⟥ ⟦⟧ ⟨⟩ ⟪⟫ ⦃⦄ ⦅⦆ ⦇⦈ ⦉⦊ ⦋⦌ ⦍⦎ ⦏⦐
        ⦑⦒ ⦓⦔ ⦕⦖ ⦗⦘ ⧀⧁ ⧄⧅ ⧏⧐ ⧑⧒ ⧔⧕ ⧘⧙ ⧚⧛ ⧸⧹ ⧼⧽ ⨫⨬ ⨭⨮ ⨴⨵ ⨼⨽ ⩤⩥ ⩹⩺ ⩽⩾ ⩿⪀
        ⪁⪂ ⪃⪄ ⪋⪌ ⪑⪒ ⪓⪔ ⪕⪖ ⪗⪘ ⪙⪚ ⪛⪜ ⪡⪢ ⪦⪧ ⪨⪩ ⪪⪫ ⪬⪭ ⪯⪰ ⪳⪴ ⪻⪼ ⪽⪾ ⪿⫀ ⫁⫂ ⫃⫄
        ⫅⫆ ⫍⫎ ⫏⫐ ⫑⫒ ⫓⫔ ⫕⫖ ⫬⫭ ⫷⫸ ⫹⫺ ⸂⸃ ⸄⸅ ⸉⸊ ⸌⸍ ⸜⸝ ⸠⸡ 〈〉 《》 「」 『』 【】 〔〕
        〖〗 〘〙 〚〛 〝〞 ﴾﴿ ︗︘ ︵︶ ︷︸ ︹︺ ︻︼ ︽︾ ︿﹀ ﹁﹂ ﹃﹄ ﹇﹈ ﹙﹚ ﹛﹜ ﹝﹞ （） ＜＞ ［］
        ｛｝ ｟｠ ｢｣
      ).to_h(&:chars).freeze

      # --- building blocks for the rules below

      # Ruby's \w is ASCII-only, so word characters are spelled out.
      w = '\p{L}\p{N}_'
      # Superscript digits and signs are exponents ("$x²"), so they must
      # not be part of an identifier.
      sup = '²³¹⁰-⁻'
      word = "[#{w}&&[^#{sup}]]"
      nondigit = "[\\p{L}\\p{No}\\p{Nl}_&&[^#{sup}]]"
      # one identifier character, for lookbehinds
      ident_char = "[#{w}'\\-:&&[^#{sup}]]"
      # What may follow a word for it to still be part of a longer
      # identifier. A single colon does not continue an identifier
      # ("@a.push: 1", "Blob:D:"), and neither does a hyphen that is not
      # followed by a letter ("$x-1").
      ident_end = "(?:#{word}|['\\-](?=[\\p{L}\\p{No}\\p{Nl}_])|::)"
      # not preceded by something that makes this the tail of a longer word
      nw = "(?<![#{w}'\\-])"

      # an identifier; a hyphen or apostrophe must be followed by a letter
      ident = "#{nondigit}#{word}*(?:['\\-]#{nondigit}#{word}*)*"
      qualified_ident = "#{ident}(?:::#{ident})*"
      # the operator part of a routine name: infix:<+>, circumfix:«[ ]»
      op_name_suffix = '(?::(?:sym)?(?:<[^>\n]+>|«[^»\n]+»|\[[^\]\n]+\]))'
      routine_name = "[!^]?#{qualified_ident}#{op_name_suffix}?"
      op_categories = '(?:infix|prefix|postfix|circumfix|postcircumfix|term|trait_mod)'
      type_name = "[A-Z]#{word}*(?:['\\-]#{nondigit}#{word}*)*(?:::#{ident})*"
      # type smileys: Int:D, Foo:U, Any:_
      smiley = "(?::[UD_](?![#{w}'\\-]))"
      after_dot = '(?:(?<=\.)(?<!\.\.)|(?<=\.[\^?&+*]))'
      subscript = '(?:\[[^\]\n]*\]|\{[^}\n]*\}|<[^>\n]*>)'
      # %h<key>, %h<<$key>>, %h«key»; kept to one line so that a stray '<'
      # in code can't swallow what follows it
      angle_subscripts = '(?:<<[^>\n]*>>|<[^>\n]*>|«[^»\n]*»)*'

      alternatives = lambda do |words|
        words.sort_by { |x| -x.length }.map { |x| Regexp.escape(x) }.join('|')
      end

      word_match = lambda do |words, suffix = ''|
        "(?<!#{ident_char})(#{words.map { |x| Regexp.escape(x) }.join('|')})" \
          "#{suffix}(?!#{ident_end})"
      end

      not_a_builtin_type = "(?!(?:#{alternatives.(BUILTIN_CLASSES)}|True|False|Nil)" \
        "#{smiley}?(?!#{ident_end}))"
      # After a dot every builtin routine is a builtin, and so is the name
      # of a type: "$x.Int" calls the coercion method, it does not name
      # the type.
      method_builtins = (BUILTINS | METHODS | BUILTIN_CLASSES).sort
      open_brackets = Regexp.escape(BRACKETS.keys.join)

      HEREDOC_OPENER = /#{nw}(qq|q|Q)[a-zA-Z]?\s*((?::[#{w}]+\s*)+)([^#{w}\s:])/

      start do
        @brace_levels = []
      end

      # Consumes the rest of a construct opened with the delimiter +opener+
      # and returns its body and its closing delimiter. Mirrored delimiters
      # nest. An unclosed construct runs to the end of the input, and has
      # an empty closing delimiter.
      def scan_delimited(stream, opener, escapes: false)
        mirror = BRACKETS[opener[0]]
        closer = mirror ? mirror * opener.length : opener
        patterns = [closer, opener].uniq.map { |x| Regexp.escape(x) }
        # a backslash hides the delimiter that follows it
        patterns << '\\\\.' if escapes
        delimiters = /#{patterns.join('|')}/m

        body = +''
        depth = 1
        loop do
          chunk = stream.scan_until(delimiters)
          if chunk.nil?
            body << stream.rest
            stream.terminate
            return [body, '']
          end

          body << chunk
          case stream.matched
          when closer then depth -= 1
          when opener then depth += 1
          end
          return [body[0...-closer.length], closer] if depth.zero?
        end
      end

      # Lexes +text+ on its own, starting in +state+.
      def sublex(text, state = :root)
        lexer = self.class.new(options)
        lexer.reset!
        lexer.push(state) unless state == :root
        delegate(lexer, text)
      end

      # Lexes what follows the opening quote of a heredoc: the rest of
      # that line, which is ordinary code, and then the heredoc's body.
      def lex_heredocs(stream, terminator, interpolate)
        rest_of_line = stream.scan(/[^\n]*/)
        sublex rest_of_line
        return unless stream.scan(/\n/)

        token Text::Whitespace, "\n"

        # the bodies follow in the order their heredocs were opened
        heredocs = [[terminator, interpolate]] + extra_heredocs(rest_of_line)
        heredocs.each_with_index do |(name, interpolates), index|
          last_line = /^[ \t]*#{Regexp.escape(name)}[ \t]*$/
          body = stream.scan_until(/(?=#{last_line})/)
          if body.nil?
            body = stream.rest
            stream.terminate
          end

          if interpolates
            sublex body, :interpolated
          else
            token Str, body
          end
          break if stream.eos?

          token Str, stream.scan(last_line)
          if index + 1 < heredocs.length && stream.scan(/\n/)
            token Text::Whitespace, "\n"
          end
        end
      end

      # Heredocs opened later on the same line, as pairs of terminator
      # and whether the body interpolates.
      def extra_heredocs(line)
        found = []
        pos = 0
        while (match = HEREDOC_OPENER.match(line, pos))
          pos = match.end(0)
          quote, adverbs, opener = match.captures
          next unless adverbs.match?(/:to\b/)

          stop = line.index(BRACKETS.fetch(opener, opener), pos)
          next unless stop

          found << [line[pos...stop], quote == 'qq' || adverbs.include?(':qq')]
        end
        found
      end

      # If you're modifying these rules, be careful if you need to process
      # '{' or '}' characters. Code can be nested in strings, and the
      # :embedded state counts braces to know where that code ends, so if
      # you process one of them, make sure you also process the other!
      state :common do
        # --- comments
        rule %r/#[`|=](([#{open_brackets}])\2*)/ do |m|
          opening = m[0]
          token Comment::Multiline, opening + scan_delimited(m, m[1]).join
        end
        rule %r/#[|=].*/, Comment::Special
        rule %r/#.*/, Comment::Single

        # deal with a special case in the Raku grammar (role q { ... })
        rule %r/(role)(\s+)(q)(\s*)/ do
          groups Keyword::Declaration, Text::Whitespace, Name, Text::Whitespace
        end

        # --- quote-like constructs: q/raw/, qq{interpolating}, Q[literal]
        # and heredocs (q:to/END/). Before the keyword and builtin rules,
        # which would otherwise take q for a word.
        rule %r/#{nw}(qq|q|Q)[a-zA-Z]?\s*(:[#{w}\s:]+)?\s*(([^0-9a-zA-Z:\s=,;)])\4*)/ do |m|
          opening = m[0]
          adverbs = m[2].to_s
          # qq strings (and the :qq / :c adverbs) interpolate
          interpolate = m[1] == 'qq' || adverbs.match?(/:(?:qq|c)\b/)
          body, closing = scan_delimited(m, m[3], escapes: true)

          if adverbs.match?(/:to\b/)
            token Str, opening + body + closing
            lex_heredocs(m, body, interpolate)
          elsif interpolate
            token Str, opening
            sublex body, :interpolated
            token Str, closing
          else
            token Str, opening + body + closing
          end
        end

        # --- curly and corner quotes: ‘raw’, “interpolating”, ｢no escapes｣
        rule %r/[‘‚][^‘’]*[’‘]/, Str::Single
        rule %r/｢[^｣]*｣/, Str
        rule %r/[“„]/, Str::Double, :dq_curly

        # --- names whose meaning depends on where they are
        # method calls: .say, .Int, .^name, .?foo
        rule %r/#{after_dot}#{word_match.(method_builtins)}/, Name::Builtin
        rule %r/#{after_dot}#{ident}/, Name::Function
        # the key of a pair is a plain word, whatever it spells: name => 1
        rule %r/(?<!#{ident_char})#{qualified_ident}(?=\s*=>)/, Name
        # operators used by name: infix:<+>(1, 2)
        rule %r/(?<!#{ident_char})#{op_categories}#{op_name_suffix}/, Name::Function
        # traits: is rw, is copy, is export
        rule %r/(?<!#{ident_char})(is)(\s+)#{word_match.(TRAITS)}/ do
          groups Keyword, Text::Whitespace, Keyword
        end
        # user-defined types: "is Foo", "of Foo", "--> Foo"
        rule %r/(?<!#{ident_char})(is|does|of|returns|handles|trusts|hides)(\s+)#{not_a_builtin_type}(#{type_name}#{smiley}?)(?!#{ident_end})/ do
          groups Keyword, Text::Whitespace, Name::Class
        end
        rule %r/(-->)(\s*)#{not_a_builtin_type}(#{type_name}#{smiley}?)(?!#{ident_end})/ do
          groups Operator, Text::Whitespace, Name::Class
        end
        # version literals: use v6.d; use v6.e.PREVIEW; use v6.d+;
        rule %r/#{nw}(use|need|require)(\s+)(v\d+(?:\.(?:\d+|\*|[A-Za-z]+))*\+?)(?![#{w}'\-])/ do
          groups Keyword::Namespace, Text::Whitespace, Num
        end
        # module names: use Foo::Bar; need Baz; (pragmas such as 'use lib' too)
        rule %r/#{nw}(use|need|require|import|no)(\s+)(#{qualified_ident})(?!#{ident_end})/ do
          groups Keyword::Namespace, Text::Whitespace, Name::Namespace
        end

        # --- declarations
        rule %r/#{word_match.(%w(class role grammar module package knowhow enum subset))}(\s+)(#{qualified_ident})/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Class
        end
        rule %r/#{word_match.(%w(sub method submethod macro))}(\s+)(#{routine_name})/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
        end
        # "sub" is optional after multi, proto and only: multi foo(Int $x) { }
        rule %r/#{word_match.(%w(multi proto only))}(\s+)(?!(?:sub|method|submethod|token|rule|regex|macro)(?!#{ident_end}))(#{routine_name})(?=\s*[({])/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
        end

        # --- keywords and other reserved words
        rule %r/#{word_match.(DECLARATORS)}/, Keyword::Declaration
        rule %r/#{word_match.(NAMESPACE_KEYWORDS)}/, Keyword::Namespace
        rule %r/#{word_match.(KEYWORDS)}/, Keyword
        rule %r/#{word_match.(%w(True False Nil))}/, Keyword::Constant
        rule %r/#{word_match.(%w(self))}/, Name::Builtin::Pseudo
        rule %r/#{word_match.(CONSTANTS)}/, Name::Constant
        rule %r/[∞∅]/, Name::Constant
        # version literals: v6.d, v1.2.3, v1.2+
        rule %r/(?<!#{ident_char})v\d+(?:\.(?:\d+|\*|[a-z]))*\+?(?!#{ident_end})/, Num
        # meta operators: Z+, X~, R-, Z=>, Rcmp, and x=, xx=
        rule %r/#{nw}[RXZ](?:\*\*|\/\/|&&|\|\||<=>|=>|==|!=|<=|>=|~~|[-+*\/%~,&|^?<>]|(?:cmp|eq|ne|lt|gt|le|ge|leg|eqv|min|max|div|mod|and|or|xor|x|xx)(?![#{w}'\-]))/, Operator
        rule %r/#{nw}(?:xx?|min|max)=(?![=~>])/, Operator
        rule %r/#{word_match.(WORD_OPERATORS, '(?!\()')}/, Operator::Word

        # --- types and routines that come with the language
        # exception and AST class families: X::AdHoc, CX::Done, RakuAST::Name...
        rule %r/(?<![#{w}':\-])(?:X|CX|RakuAST)(?:::[A-Za-z][#{w}'\-]*)+#{smiley}?(?![#{w}'\-])/, Keyword::Type
        rule %r/#{word_match.(BUILTIN_CLASSES, "#{smiley}?")}/, Keyword::Type
        rule %r/#{word_match.(BUILTINS)}/, Name::Builtin
        # a user-defined type: with a smiley, or constraining a variable
        rule %r/(?<!#{ident_char})#{type_name}#{smiley}/, Name::Class
        rule %r/(?<!#{ident_char})#{type_name}(?=\s+[$@%&\\])/, Name::Class
        rule %r/(?<=[#{w}>])#{smiley}/, Keyword::Type

        # --- variables
        # attributes ($!x, $.x) and compile-time / pod variables ($?FILE, $=pod)
        rule %r/[$@%&][.!]#{qualified_ident}#{angle_subscripts}/, Name::Variable::Instance
        rule %r/[$@%&][?=]#{ident}#{angle_subscripts}/, Name::Variable::Magic
        rule %r/::\?[#{w}]+/, Name::Variable::Global
        rule %r/[$@%&]\*#{qualified_ident}#{angle_subscripts}/, Name::Variable::Global
        rule %r/\$[!\/¢]#{angle_subscripts}/, Name::Variable::Global
        rule %r/&#{op_categories}#{op_name_suffix}/, Name::Variable
        rule %r/[$@%&][\^:~]?(?:::)?(?:#{qualified_ident}|\d+)#{angle_subscripts}/, Name::Variable
        rule %r/\$(?:<[^>\n]*>)+/, Name::Variable
        # anonymous variables: "state $ = 0", "$++"
        rule %r/[$@](?=[\s=;,)\]]|\+\+|--)/, Name::Variable
        rule %r/%(?=[,)])/, Name::Variable
        # contextualizers: $(...), @(...), @$x, $@a
        rule %r/[$@](?=[(\[{])/, Operator
        rule %r/[$@%&](?=[$@%&][#{w}.!*?^])/, Operator
        # sigilless variables (\x), capture literals \(1, 2) and unspace
        rule %r/\\#{ident}/, Name::Variable
        rule %r/\\(?=[\s(])/, Operator
        # type captures: ::T
        rule %r/::#{ident}/, Name::Class

        # --- numbers
        rule %r/0x[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*/, Num::Hex
        rule %r/0o[0-7]+(?:_[0-7]+)*/, Num::Oct
        rule %r/0b[01]+(?:_[01]+)*/, Num::Bin
        rule %r/0d\d+(?:_\d+)*/, Num::Integer
        # radix literals: :16<FF>
        rule %r/:\d+<[0-9a-z_.]+>/i, Num
        # imaginary numbers
        rule %r/(?:\d+(?:_\d+)*(?:\.\d+(?:_\d+)*)?|\.\d+(?:_\d+)*)(?:e[+-]?\d+)?i(?![#{w}'\-])/i, Num::Float
        rule %r/(?:\d+(?:_\d+)*)?\.\d+(?:_\d+)*(?:e[+-]?\d+)?/i, Num::Float
        rule %r/\d+(?:_\d+)*e[+-]?\d+/i, Num::Float
        rule %r/\d+(?:_\d+)*/, Num::Integer
        # rational and complex literals: <1/3>, <1+2i>
        rule %r/<[-+]?\d+\/\d+>/, Num
        rule %r/<[-+]?[\d.]+[-+][\d.]+i>/, Num

        # --- operators that could be mistaken for quotes
        # hyper operators: »+«, >>+<<, +« (prefix), »++ and ».say (postfix)
        rule %r/(?:«|»|<<|>>)[-+*\/%~=!&|^?<>]+(?:«|»|<<|>>)/, Operator
        rule %r/[-+*\/%~!?|^]+«/, Operator
        # ... and around a bracketed operator: «[op]«
        rule %r/[«»]\[[^\]\n]+\][«»]|>>\[[^\]\n]+\]<</, Operator
        rule %r/(?:»|>>)(?=\.[#{w}^?!(]|\+\+|--|[\[{<(])/, Operator
        # reduction operators: [+], [\*], [<=], [max], [Z+]
        rule %r/(?<![#{w}\])}>'\-])\[\\?(?:[RXZ]?[-+*\/%~=<>!&|^?,]+|[RXZ]?(?:min|max|gcd|lcm|and|or|xor|x|xx|cmp|eq|ne|lt|gt|le|ge|leg|eqv))\]/, Operator
        # quote-like words with interpolation: «a $b» and <<a $b>>. After
        # an operator or a term these are hyper operators, not quotes.
        rule %r/(?<![#{w}\])}>+\-*\/%~!?^|&.])«/, Str::Double, :ww_guillemets
        rule %r/(?<![#{w}\])}>])<<(?!=)/, Str::Double, :ww_angles
        rule %r/(?!<->)<[^\s=<>{};()](?:[^<>{};()]*[^\s<>{};()])?>/, Str

        # --- labels, pairs and operators
        # loop labels: OUTER: for ...
        rule %r/#{nw}([A-Z][A-Z0-9_]*)(:)(?=\s*(?:for|while|until|loop|repeat|given|if|unless|do|\{|$))/ do
          groups Name::Label, Punctuation
        end
        # colon-pairs and adverbs: :name, :!flag, :name(...), :2nd
        rule %r/(:!?)(#{ident})/ do
          groups Punctuation, Name::Attribute
        end
        rule %r/(:)(\d+)(#{ident})/ do
          groups Punctuation, Num::Integer, Name::Attribute
        end
        # superscript exponents: $x², A⁻¹
        rule %r/[#{sup}]+/, Operator
        # a prefix operator in front of a function reference: ~&foo, +&bar
        rule %r/[-~+?!|^](?=&[\p{L}\p{No}\p{Nl}_])/, Operator
        # assignment meta operators: +=, //=, ||=, ...
        rule %r/(?:\*\*|\/\/|\|\||&&|%%|[-+*\/%~|&^?])=(?![=~>])/, Operator
        rule %r/#{alternatives.(SYMBOL_OPERATORS)}/, Operator
        rule %r/#{qualified_ident}/, Name
        rule %r/'(?:\\\\|\\[^\\]|[^'\\])*'/, Str::Single
        rule %r/"/, Str::Double, :dq_string
        rule %r/[;,:()\[\]]/, Punctuation
      end

      state :root do
        mixin :common
        rule %r/[{}]/, Punctuation
        rule %r/\s+/, Text::Whitespace
        # anything else that is not a letter: user-defined operators, ...
        rule %r/[^#{w}\s]/, Operator
        rule %r/./m, Text
      end

      # Code embedded in something else (a closure inside a string) is
      # lexed in this state, which keeps count of its own braces so it
      # knows when to hand control back.
      state :embedded do
        mixin :common
        rule %r/\{/ do
          token Punctuation
          @brace_levels[-1] += 1
        end
        rule %r/\}/ do
          token Punctuation
          @brace_levels[-1] -= 1
          if @brace_levels.last.zero?
            @brace_levels.pop
            pop!
          end
        end
        rule %r/\s+/, Text::Whitespace
        rule %r/[^#{w}\s]/, Operator
        rule %r/./m, Text
      end

      # what can appear inside an interpolating string
      state :interpolation do
        rule %r/\\(?:[abefnrt0"'\\$@%&{}<>«»]|[xXoOcCdD]\[[^\]\n]*\]|x[0-9a-fA-F]+)/, Str::Escape
        rule %r/\\./m, Str::Double
        # contextualizers: $(...), @(...)
        rule %r/[$@%&]\((?:[^()\n]|\([^()\n]*\))*\)/, Str::Interpol
        # scalars always interpolate, optionally followed by subscripts
        # and method calls with parentheses
        rule %r/\$(?:[*.!^?=~:]?#{qualified_ident}|[!\/&¢]|\d+|<[^>\n]+>)(?:#{subscript}|\.#{ident}\([^)\n]*\))*/, Str::Interpol
        # arrays, hashes and functions only if they are subscripted/called
        rule %r/[@%][*.!^?=~:]?#{qualified_ident}#{subscript}(?:#{subscript})*/, Str::Interpol
        rule %r/&#{ident}\([^)\n]*\)/, Str::Interpol
        rule %r/\{/ do
          token Punctuation
          @brace_levels << 1
          push :embedded
        end
      end

      # the body of a qq string or of an interpolating heredoc
      state :interpolated do
        mixin :interpolation
        rule %r/[^\\$@%&{]+/, Str::Double
        rule %r/[$@%&\\]/, Str::Double
      end

      state :dq_string do
        rule %r/"/, Str::Double, :pop!
        mixin :interpolation
        rule %r/[^"\\$@%&{]+/, Str::Double
        rule %r/[$@%&\\]/, Str::Double
      end

      state :dq_curly do
        rule %r/[”“]/, Str::Double, :pop!
        mixin :interpolation
        rule %r/[^”“\\$@%&{]+/, Str::Double
        rule %r/[$@%&\\]/, Str::Double
      end

      state :ww_guillemets do
        rule %r/»/, Str::Double, :pop!
        mixin :interpolation
        rule %r/[^»\\$@%&{]+/, Str::Double
        rule %r/[$@%&\\]/, Str::Double
      end

      state :ww_angles do
        rule %r/>>/, Str::Double, :pop!
        mixin :interpolation
        rule %r/[^>\\$@%&{]+/, Str::Double
        # (a lone '>' does not close the quote)
        rule %r/[$@%&\\>]/, Str::Double
      end
    end
  end
end
