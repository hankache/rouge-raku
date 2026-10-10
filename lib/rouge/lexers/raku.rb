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
        assoc built cached copy default DEPRECATED dynamic encoded
        equiv export hidden hidden-from-backtrace hidden-from-USAGE
        implementation-detail looser native nativesize nodal pure raw
        readonly repr required rw symbol test-assertion tighter
      ).freeze

      # names of the phasers that can follow "will"
      WILL_TRAITS = %w(
        begin check end enter first keep leave undo
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
        abs2rel absolute accept ACCEPTS accepts_type accessed acquire
        act action actions add add_attribute add_enum_value
        add_fallback add_method add_parent add_private_method add_role
        add_stash add_trustee adverb after allocate allof
        alternative-names annotations antipair antipairs anyof api
        app_lifetime arch archetypes archname are args arity
        ASSIGN-KEY ASSIGN-POS assuming ast at AT-KEY AT-POS attributes
        auth backtrace base base-repeating base_type basename batch
        before BIND-KEY BIND-POS bind-stderr bind-stdin bind-stdout
        bind-udp bits bless block bool-only bounds break Bridge broken
        BUILD build-date bytecode-size bytes cache CALL-ME
        calling-package can cancel candidates cando canonpath caps
        caption capture catdir categorize-list catfile catpath cause
        changed child child-name child-typename chunks classify-list
        cleanup clone close-stdin closed code codes collate column
        command comment compiler composalizer compose compose_type
        compose_values composer compute_mro concise condition config
        configure_destroy configure_type_checking conj connect
        constraints construct contains contents count count-only
        cpu-cores cpu-usage CREATE create_type created cue curdir
        curupdir d day day-fraction day-of-month day-of-week
        day-of-year daycount days-in-month days-in-year dd-mm-yyyy
        declaration decode decoder default DEFINITE definite delayed
        delegate_methods_to delegating_methods_to DELETE-KEY
        DELETE-POS denominator desc DESTROY destroyers dev devnull
        devtype did-you-mean dir-sep dir-with-entries dirname
        DISTROnames do does dynamic e eager earlier enclosing encode
        encoder encoding ends-with enum_from_value enum_value_list
        enum_values enums eof err exception excludes-max excludes-min
        EXISTS-KEY EXISTS-POS exitcode expected export_callback
        extension f feature file filename find_method
        find_method_qualified find_private_method finish
        first-date-in-month flatmap flush flush_cache fmt format
        formatter freeze from from-list from-loop from-posix
        from-slurpy full generate_mixin get_value got grab grabpairs
        handle handled handles hardware has_accessor headers hh-mm-ss
        hidden hides hour HOW how hyper id illegal im in in-range
        in-timezone indent indices infinite infix inode
        install_method_cache instead int-bounds interval invalid-str
        invert invocant is-absolute is-hidden is-implementation-detail
        is-initial-thread is-int is-lazy is-leap-year is-relative
        is-routine is-setting is-win is_composed is_mixin is_trusted
        is_type isa isNaN iterator julian-date keep kept KERNELnames
        key keyof kill kxxv l lang last last-date-in-month later lazy
        leading level line listen live local lock lookup made make
        match maxpairs merge message method method_table methods
        migrate minpairs minus minute misplaced mixin mixin_attribute
        mm-dd-yyyy mode modified modified-julian-date modifier month
        mro mro_unhidden multi multi-invocant multiness my name named
        named_names narrow native-descriptor new new-from-daycount
        new-from-pairs new_type next next-handle
        next-interesting-index nice nl-in nl-out nominalize norm nude
        numerator of offset offset-in-hours offset-in-minutes old
        on-close on-switch opened operation optional orig os-error
        osname out out-buffer outer outer-caller-idx package
        package-kind package-name packages pair pairup parameter
        parameterize_type params parent parent-name parents parse
        parsefile parts path path-sep payload peer-host peer-port perl
        phaser pickpairs pid placeholder plus polar poll polymod port
        pos positional posix postfix postmatch precomp-ext
        precomp-target pred prefix prematch pretend_to_be
        pretending_to_be print-nl print-to private
        private_method_names private_method_table private_methods proc
        protect publish_method_cache pull-one push-all push-at-least
        push-exactly push-until-lazy qualifier-type quit r race radix
        raku range raw re read readchars readonly ready reallocate
        reals reason rebless receive recv redispatcher redo rel2abs
        relative release remove replace-with replacement REPR reserved
        resolve restore result resume rethrow returns right role
        roles_to_compose rolish rootdir rotor routine-type rw rwx s
        schedule-on scheduler scope second seek send serial
        set-instruments set_api set_auth set_composalizer
        set_export_callback set_hidden set_is_mixin
        set_mixin_attribute set_name set_package set_parameterizer
        set_rw set_value set_ver set_why setup_finalization
        setup_mixin_cache shape share shortname sibling sigil signals
        signature sink sink-all skip-at-least skip-at-least-pull-one
        skip-one slice slurp-rest slurpy socket-host socket-port
        source source-package spawn SPEC splitdir splitpath stable
        start started starts-with status stderr stdout sub_signature
        subbuf subname subparse subst subst-mutate substr-eq succ
        suffix summary t tap target target-name tell then throttle
        throw timezone tmpdir to to-posix today toggle total trailing
        trans tree truncated-to trusts try_acquire trying twigil type
        type_captures type_check type_parameter_at type_parameterized
        type_parameters typename udp uncaught_handler univals unlock
        unset unwrap updir usage-name utc value VAR variable ver
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
        str uint bool ssize_t ulong ulonglong utf16 void
      ).freeze

      WORD_OPERATORS = %w(
        after and andthen before but cmp coll div eq eqv ff fff gcd ge
        gt lcm le leg lt max min minmax mod ne not notandthen or
        orelse R so unicmp x X xor xx Z
      ).freeze

      # terms that stand for a value, and the values of the enumerations
      # that come with the language
      CONSTANTS = %w(
        π τ ∞ 𝑒 pi tau Inf NaN e i BigEndian Broken Empty FileChanged
        FileRenamed IterationEnd Kept Less LittleEndian More
        NativeEndian PF_INET PF_INET6 Planned Same SeekFromBeginning
        SeekFromCurrent SeekFromEnd SIGABRT SIGALRM SIGBREAK SIGBUS
        SIGHUP SIGINT SIGKILL SIGTERM SIGUSR1 SOCK_DGRAM SOCK_PACKET
        SOCK_RAW SOCK_RDM SOCK_SEQPACKET SOCK_STREAM
      ).freeze

      # symbolic operators, including the Unicode synonyms
      SYMBOL_OPERATORS = %w(
        ... … <=> ==>> <<== ==> <== === =:= =~= !~~ ~~ ::= := ^..^ ..^
        ^.. .. ** ++ -- && || // ^^ ?? !! == != <= >= => %% +& +| +^
        +< +> ~& ~| ~^ ~< ~> ?& ?| ?^ --> <-> -> ! ? + - * / % ~ | & ^
        < > = . ∈ ∉ ∋ ∌ ⊂ ⊄ ⊃ ⊅ ⊆ ⊈ ⊇ ⊉ ≼ ≽ ∪ ∩ ∖ ⊖ ⊍ ⊎ ≤ ≥ ≠ ≅ × ÷ −
        ∘ ⚛ ≡ ≢ ⩶ ⩵ ∊ ∍
      ).freeze

      # rules available in every grammar: <ws>, <alpha>, <before ...>, ...
      REGEX_BUILTINS = %w(
        alnum alpha after at before blank cntrl digit graph ident
        lower print punct same space upper wb ws ww xdigit
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

      # what the text of a Pod formatting code looks like
      POD_FORMATS = {
        'B' => Generic::Strong, 'I' => Generic::Emph, 'C' => Str::Backtick,
        'K' => Str::Backtick, 'T' => Str::Backtick, 'V' => Str::Backtick,
      }.freeze

      # --- building blocks for the rules below

      # the lines of a Pod paragraph: up to a blank line or a directive
      pod_paragraph = '(?:(?![ \t]*$|[ \t]*=[A-Za-z])[^\n]*\n?)*'

      # Ruby's \w, \d and \s are ASCII-only. Raku is not, so the rules use
      # \p{Nd} and \p{Space}, and word characters are spelled out.
      w = W = '\p{L}\p{N}_'
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
      # A number can start with its decimal point (.5), but not right after
      # a term: in "foo().5" and "@a[0].5" the dot is not part of a number.
      # (it looks ahead for the dot first, so as not to look behind at
      # every character)
      leading_dot = "(?=\\.)(?<![#{w})\\]}])\\."
      # the operator part of a routine name: infix:<+>, circumfix:«[ ]»
      op_name_suffix = '(?::(?:sym)?(?:<<(?!=>)(?:(?!>>)[^\n;])+>>|<[^>\n]+>|«[^»\n]+»|' \
        '\[(?:"[^"\n]*"|\'[^\'\n]*\'|[^\]\n])+\]))'
      routine_name = "[!^]?#{qualified_ident}#{op_name_suffix}?"
      op_categories = '(?:infix|prefix|postfix|circumfix|postcircumfix|term|trait_mod)'
      type_name = "[A-Z]#{word}*(?:['\\-]#{nondigit}#{word}*)*(?:::#{ident})*"
      # type smileys: Int:D, Foo:U, Any:_
      smiley = "(?::[UD_](?![#{w}'\\-]))"
      after_dot = '(?:(?<=\.)(?<!\.\.)|(?<=\.[\^?&+*]))'
      subscript = '(?:\[[^\]\n]*\]|\{[^}\n]*\}|<[^>\n]*>)'
      # the arguments of a call, with one level of nested parentheses;
      # a parenthesis in a quoted string does not count
      # (atomic and possessive, so that it can not backtrack for ages)
      arguments = '\((?>\'[^\'\n]*\'|"[^"\n]*"|[^()\n]|\([^()\n]*\))*+\)'
      # what can follow a variable in a string: a subscript or a method call
      # A chain of method calls counts as long as it ends in parentheses
      # ("$x.name.uc()"), and so does a call of the variable ("$f()").
      postfix = "(?:#{subscript}|#{arguments}|(?:\\.[\\^?&]?#{ident})+#{arguments})"
      # the rest of an extended identifier: $foo:bar<baz>, $take-me:['home'].
      # Parentheses only belong to it after a name: &code:(Int) has a
      # signature.
      extended = "(?::(?:#{ident})?(?:<[^>\\n]*>|«[^»\\n]*»|\\[[^\\]\\n]*\\]|" \
        "(?<=[#{w}])\\([^)\\n]*\\)))*"
      # %h<key>, %h<<$key>>, %h«key»; kept to one line so that a stray '<'
      # in code can't swallow what follows it
      angle_subscripts = '(?:<<[^>\n]*>>|<[^>\n]*>|«[^»\n]*»)*'

      # Where a "/" starts a regex rather than being a division: after an
      # operator or an opening bracket, or after a word that takes a term.
      regex_words = %w(
        say put print when if elsif unless while until given with without
        and or not so return grep map first split comb match subst
        contains ff fff xor andthen orelse
      )
      regex_position = "(?=\\p{Space}*\\/)(?:(?<=[=(,{\\[;:!~|&?])|(?<==>)|" \
        "#{regex_words.map { |x| "(?<=\\b#{x} )" }.join('|')})"
      open_brackets = Regexp.escape(BRACKETS.keys.join)

      # Where q, m, s and the like can start a quote: not after a dot, where
      # they are method names ("$file.s / 1024").
      quote_start = "(?<![#{w}'\\-.])"
      # the adverbs of a quote: q:to, qq:!c, m:i:g
      adverbs = "(?:\\p{Space}*:!?[#{w}]+)+"
      # What can delimit a quote, besides a bracket. Most punctuation
      # could, but in "q.new" and "q = 1" q is a name. An apostrophe in
      # front of a letter is part of an identifier (q'x), unless adverbs
      # came first (q:to 'END'), which the rule captures as its group
      # number +adverbs+.
      quote_delimiter = lambda do |adverbs|
        "(?:[\\/!|\"~^%@`§]|(?(#{adverbs})'|'(?![\\p{L}_])))"
      end
      # Between a quote word and its delimiter, whitespace can only come
      # before a bracket or a slash: in "q ~~ $x" and "m ?? 1 !! 2", q and
      # m are names.
      before_delimiter = "(?:\\p{Space}*(?=[#{open_brackets}\\/])|)"
      # where a "<" starts a word list rather than being a comparison
      term_position = "(?=\\p{Space}*<)(?:(?<=[=(,\\[])|(?<=\\bfor ))"
      # "token", "rule" and "regex" are ordinary words in "$x.rule",
      # "rule => 1" or "/regex/"
      not_a_regex_declarator = "(?<![#{w}'.:$@%&\\/<\\-])"

      # A regex matching the longest of +words+. Common prefixes are shared,
      # so that it does not slow down as the list grows.
      any_of = lambda do |words|
        tree = {}
        words.each do |x|
          x.each_char.inject(tree) { |node, char| node[char] ||= {} }[:end] = true
        end

        build = lambda do |node|
          branches = node.reject { |char, _| char == :end }.map do |char, rest|
            Regexp.escape(char) + build.(rest)
          end
          next '' if branches.empty?
          next branches.first if branches.length == 1 && !node[:end]

          "(?:#{branches.join('|')})#{'?' if node[:end]}"
        end
        build.(tree)
      end

      word_match = lambda do |words, suffix = ''|
        "(?<!#{ident_char})(#{any_of.(words)})" \
          "#{suffix}(?!#{ident_end})"
      end

      not_a_builtin_type = "(?!(?:#{any_of.(BUILTIN_CLASSES)}|True|False|Nil)" \
        "#{smiley}?(?!#{ident_end}))"
      # After a dot every builtin routine is a builtin, and so is the name
      # of a type: "$x.Int" calls the coercion method, it does not name
      # the type.
      method_builtins = (BUILTINS | METHODS | BUILTIN_CLASSES).sort
      builtins = Set.new(BUILTINS)

      OPEN_BRACKET = /[#{open_brackets}]/
      HEREDOC_OPENER = /#{nw}(qq|q|Q)(ww|[a-zA-Z])?\p{Space}*((?::!?[#{w}]+\p{Space}*)+)([^#{w}\p{Space}:])/
      HEREDOC_ADVERB = /:(?:to|heredoc)\b/
      # What a quote can interpolate: scalars, arrays, hashes, function
      # calls, closures and backslash escapes. Each has an adverb that
      # turns it on, with a short and a long name: q:s, q:scalar
      INTERPOLATIONS = {
        's' => :s, 'scalar' => :s, 'a' => :a, 'array' => :a, 'h' => :h, 'hash' => :h,
        'f' => :f, 'function' => :f, 'c' => :c, 'closure' => :c,
        'b' => :b, 'backslash' => :b,
      }.freeze
      EVERY_INTERPOLATION = INTERPOLATIONS.values.uniq.freeze
      SIGIL_INTERPOLATIONS = { '$' => :s, '@' => :a, '%' => :h, '&' => :f }.freeze

      start do
        @brace_levels = []
        @interpolations = EVERY_INTERPOLATION
        @pod_formats = []
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

      # Consumes the rest of a regex (or of the replacement of a
      # substitution) opened with the delimiter +opener+ and returns its
      # body and its closing delimiter. Unlike #scan_delimited this steps
      # over quoted strings, so the delimiter may appear in them:
      # rx/ '/tmp/' .* /
      def scan_regex(stream, opener, match_variable: false)
        mirror = BRACKETS[opener[0]]
        closer = mirror ? mirror * opener.length : opener
        closing = /#{Regexp.escape(closer)}/
        opening = mirror && /#{Regexp.escape(opener)}/
        plain = /[^\\'"$#{Regexp.escape((opener[0] + closer[0]).squeeze)}]+/
        # only a quote that is closed on the same line counts
        quoted = /'(?:\\.|[^'\\\n])*'|"(?:\\.|[^"\\\n])*"/
        # "$/" in the replacement of s/.../.../ is the match variable,
        # provided the real delimiter still follows on this line
        variable = match_variable && /\$#{closing}(?=[^\n]*#{closing})/

        body = +''
        depth = 1
        until stream.eos?
          if (text = stream.scan(plain) || stream.scan(/\\./m) || stream.scan(quoted) ||
                     (variable && stream.scan(variable)))
            body << text
          elsif stream.scan(closing)
            depth -= 1
            return [body, closer] if depth.zero?

            body << closer
          elsif opening && stream.scan(opening)
            depth += 1
            body << opener
          else
            body << stream.getch
          end
        end
        [body, '']
      end

      # Lexes one delimited part of a regex-like construct, whose opening
      # delimiter has just been consumed. The body is lexed in +state+,
      # or is a plain token if there is none.
      def lex_regex_part(stream, opener, state, match_variable: false)
        body, closing = scan_regex(stream, opener, match_variable: match_variable)
        if state
          sublex body, state
        else
          token Str::Regex, body
        end
        token Str::Regex, closing
      end

      # s/pattern/replacement/, s{pattern}{replacement}, tr/from/to/, ...
      def lex_substitution(stream, opening, kind, opener)
        transliteration = kind.downcase == 'tr'

        token Str::Regex, opening
        lex_regex_part(stream, opener, transliteration ? nil : :regex_body)

        replacement = transliteration ? nil : :interpolated
        if BRACKETS[opener[0]].nil?
          # s/a/b/ : the replacement follows directly, with the same delimiter
          lex_regex_part(stream, opener, replacement, match_variable: true)
        elsif stream.check(/\p{Space}*#{OPEN_BRACKET}/o)
          # s{a}{b} : another bracketed group, possibly after whitespace.
          # Otherwise it is s{a} = b, an ordinary assignment.
          token Text::Whitespace, stream.scan(/\p{Space}*/)
          opener = stream.scan(/(.)\1*/m)
          token Str::Regex, opener
          lex_regex_part(stream, opener, replacement)
        end
      end

      # Whether what follows the opening "s[" is a substitution, s[a] = 'b',
      # s[a] += 1 or s[a][b], rather than an index into something called
      # s: s[0]
      def substitution_follows?(stream, opener)
        start = stream.pos
        _, closing = scan_regex(stream, opener)
        found = !closing.empty? && stream.match?(/\p{Space}*(?:[-+*\/%~|&^]{0,2}=(?![=>~:])|#{OPEN_BRACKET})/o)
        stream.pos = start
        found
      end

      # Lexes a Pod block whose content is not Pod: its first line, of
      # which +opening+ are the tokens up to the +name+ of the block and
      # +config+ is what follows it, and then its +body+. Code is Raku,
      # unless the block says that it is something else: =begin code
      # :lang<shell>
      def lex_pod_verbatim(name, config, body, opening)
        token Text::Whitespace, opening[0]
        token Comment::Preproc, opening[1]
        token Text::Whitespace, opening[2]
        token Name::Namespace, name
        sublex config, :pod_config_line

        if name == 'code' && !config.match?(/:lang<(?!raku>)/)
          sublex body
        else
          token Comment::Multiline, body
        end
      end

      # Opens the Pod formatting code +letter+, as in B<bold>. What closes
      # it, how its text looks and how many angle brackets are open inside
      # it are kept until it is closed.
      def open_pod_format(letter, opener)
        token Name::Decorator, letter
        token Punctuation, opener
        closer = BRACKETS[opener[0]] * opener.length
        @pod_formats << [closer, POD_FORMATS.fetch(letter, Comment::Multiline), 0]
        push :pod_format
      end

      # Lexes +text+ on its own, starting in +state+.
      def sublex(text, state = :root)
        lexer = self.class.new(options)
        lexer.reset!
        lexer.push(state) unless state == :root
        yield lexer if block_given?
        delegate(lexer, text)
      end

      # What the quote +word+ interpolates, given the letter that follows
      # it (Qs) and its +adverbs+ (q:s, qq:!c).
      def interpolations_of(word, letter, adverbs)
        found = word == 'qq' ? EVERY_INTERPOLATION.dup : []
        found << INTERPOLATIONS[letter] if INTERPOLATIONS.key?(letter)
        adverbs.scan(/:(!?)([#{W}]+)/o) do |negated, name|
          kinds = %w(qq double).include?(name) ? EVERY_INTERPOLATION : [INTERPOLATIONS[name]].compact
          found = negated.empty? ? found | kinds : found - kinds
        end
        found
      end

      # Lexes the +body+ of a quote, in which only +interpolations+ are
      # special.
      def lex_quoted(body, interpolations)
        if interpolations.empty?
          token Str, body
        else
          sublex(body, :interpolated) { |lexer| lexer.interpolations = interpolations }
        end
      end

      attr_writer :interpolations

      # Whether the string being lexed interpolates +kind+. Code inside a
      # string is code like any other, and so are the strings in it.
      def interpolates?(kind)
        !@brace_levels.empty? || @interpolations.include?(kind)
      end

      # Lexes what follows the opening quote of a heredoc: the rest of
      # that line, which is ordinary code, and then the heredoc's body.
      def lex_heredocs(stream, terminator, interpolations)
        rest_of_line = stream.scan(/[^\n]*/)
        sublex rest_of_line
        return unless stream.scan(/\n/)

        token Text::Whitespace, "\n"

        # the bodies follow in the order their heredocs were opened
        heredocs = [[terminator, interpolations]] + extra_heredocs(rest_of_line)
        heredocs.each_with_index do |(name, interpolated), index|
          last_line = /^[ \t]*#{Regexp.escape(name)}[ \t]*$/
          body = stream.scan_until(/(?=#{last_line})/)
          if body.nil?
            body = stream.rest
            stream.terminate
          end

          lex_quoted(body, interpolated)
          break if stream.eos?

          token Str, stream.scan(last_line)
          if index + 1 < heredocs.length && stream.scan(/\n/)
            token Text::Whitespace, "\n"
          end
        end
      end

      # Heredocs opened later on the same line, as pairs of terminator
      # and what the body interpolates.
      def extra_heredocs(line)
        found = []
        pos = 0
        while (match = HEREDOC_OPENER.match(line, pos))
          pos = match.end(0)
          quote, letter, adverbs, opener = match.captures
          next unless adverbs.match?(HEREDOC_ADVERB)

          stop = line.index(BRACKETS.fetch(opener, opener), pos)
          next unless stop

          found << [line[pos...stop], interpolations_of(quote, letter, adverbs)]
        end
        found
      end

      # If you're modifying these rules, be careful if you need to process
      # '{' or '}' characters. Code can be nested in strings, and the
      # :embedded state counts braces to know where that code ends, so if
      # you process one of them, make sure you also process the other!
      state :common do
        # --- Pod and regexes. These can start with whitespace, which the
        # rules after them skip.
        # Pod: everything after =finish, a delimited block (=begin pod ...
        # =end pod), or a paragraph or abbreviated block, which ends at the
        # first blank line
        rule %r/^=finish\b.*|^(\p{Space}*)=begin\p{Space}+([#{w}]+)\b.*?^\1=end\p{Space}+\2|^\p{Space}*=for.*?\n\p{Space}*?\n|^=.*?\n\p{Space}*?\n/m do |m|
          sublex m[0], :pod_body
        end
        # a regex without m or rx: $s ~~ /x/, .subst(/x/, ''), say /x/
        # It has to end on the line it starts on, as the "/" may be a
        # division after all, except after a smartmatch, where it can not.
        rule %r/#{regex_position}(\p{Space}*)(\/)(?!\/)(?:(?<=~~\/|~~\p{Space}\/)|(?=(?:\\[\s\S]|[^\/\\\n])*\/))/ do |m|
          opener = m[2]
          groups Text::Whitespace, Str::Regex
          lex_regex_part(m, opener, :regex_body)
        end

        # a word list where a term is expected, which unlike the general
        # rule for <a b c> further down can start with a space, span lines
        # and hold any character: my @a = < a " b >;
        rule %r/#{term_position}(\p{Space}*)(<(?!<|=?\])\p{Space}[^<>]*>)/ do
          groups Text::Whitespace, Str
        end

        # --- whitespace and punctuation. No rule below starts with either,
        # and they are the most common tokens, so they are not made to
        # wait for all the other rules to fail first.
        rule %r/\p{Space}+/, Text::Whitespace
        rule %r/[;,()\]]/, Punctuation

        # --- comments
        rule %r/#[`|=](([#{open_brackets}])\2*)/ do |m|
          opening = m[0]
          token Comment::Multiline, opening + scan_delimited(m, m[1]).join
        end
        rule %r/#[|=].*/, Comment::Special
        rule %r/#.*/, Comment::Single

        # --- variables. Nothing else starts with a sigil either.
        # attributes ($!x, $.x) and compile-time / pod variables ($?FILE, $=pod)
        rule %r/[$@%&][.!]#{qualified_ident}#{angle_subscripts}/, Name::Variable::Instance
        rule %r/[$@%&][?=]#{ident}#{angle_subscripts}/, Name::Variable::Magic
        rule %r/::\?[#{w}]+/, Name::Variable::Global
        rule %r/[$@%&]\*#{qualified_ident}#{angle_subscripts}/, Name::Variable::Global
        rule %r/\$[!\/¢]#{angle_subscripts}/, Name::Variable::Global
        # the & sigil names a routine: &infix:<+>, &squared, &squared(2),
        # which may be one that comes with the language: &elems
        rule %r/&#{op_categories}#{op_name_suffix}/, Name::Function
        rule %r/&(?:::)?(#{qualified_ident})/ do |m|
          token builtins.include?(m[1]) ? Name::Builtin : Name::Function
        end
        rule %r/[$@%&][\^:~]?(?:::)?(?:#{qualified_ident}#{extended}|\p{Nd}+)#{angle_subscripts}/, Name::Variable
        rule %r/\$(?:<[^>\n]*>)+/, Name::Variable
        # anonymous variables: "state $ = 0", "$++"
        rule %r/[$@](?=[\p{Space}=;,)\]]|\+\+|--)/, Name::Variable
        rule %r/%(?=[,)])/, Name::Variable
        # contextualizers: $(...), @(...), @$x, $@a
        rule %r/[$@](?=[(\[{])/, Operator
        rule %r/[$@%&](?=[$@%&][#{w}.!*?^])/, Operator
        # sigilless variables (\x), capture literals \(1, 2) and unspace
        rule %r/\\#{ident}/, Name::Variable
        rule %r/\\(?=[\p{Space}(])/, Operator
        # type captures: ::T
        rule %r/::#{ident}/, Name::Class

        # --- numbers. Nothing else starts with a digit.
        rule %r/0x[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*/, Num::Hex
        rule %r/0o[0-7]+(?:_[0-7]+)*/, Num::Oct
        rule %r/0b[01]+(?:_[01]+)*/, Num::Bin
        rule %r/0d\p{Nd}+(?:_\p{Nd}+)*/, Num::Integer
        # radix literals: :16<FF>
        rule %r/:\p{Nd}+<[0-9a-z_.]+>/i, Num
        # imaginary numbers
        rule %r/(?:\p{Nd}+(?:_\p{Nd}+)*(?:\.\p{Nd}+(?:_\p{Nd}+)*)?|#{leading_dot}\p{Nd}+(?:_\p{Nd}+)*)(?:e[+-]?\p{Nd}+)?i(?![#{w}'\-])/i, Num::Float
        rule %r/(?:\p{Nd}+(?:_\p{Nd}+)*\.|#{leading_dot})\p{Nd}+(?:_\p{Nd}+)*(?:e[+-]?\p{Nd}+)?/i, Num::Float
        rule %r/\p{Nd}+(?:_\p{Nd}+)*e[+-]?\p{Nd}+/i, Num::Float
        rule %r/\p{Nd}+(?:_\p{Nd}+)*/, Num::Integer
        # the other characters that are numbers: ⅒, ½, Ⅷ
        rule %r/[\p{No}\p{Nl}&&[^#{sup}]]/, Num
        # rational and complex literals: <1/3>, <1+2i>
        rule %r/<[-+]?\p{Nd}+\/\p{Nd}+>/, Num
        rule %r/<[-+]?[\p{Nd}.]+[-+][\p{Nd}.]+i>/, Num

        # --- regex declarations, only when a name or a block follows
        rule %r/#{not_a_regex_declarator}(regex|token|rule)(\p{Space}+)(#{ident}:sym)/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
          push :token_sym_brackets
        end
        rule %r/#{not_a_regex_declarator}(regex|token|rule)(?=\p{Space}+[\p{L}\p{No}\p{Nl}_]|\p{Space}*\{)(?!\p{Space}+[#{w}]+\p{Space}*=>)(\p{Space}*)(#{qualified_ident})?/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
          push :pre_token
        end

        # deal with a special case in the Raku grammar (role q { ... })
        rule %r/(role)(\p{Space}+)(q)(\p{Space}*)/ do
          groups Keyword::Declaration, Text::Whitespace, Name, Text::Whitespace
        end

        # --- quote-like constructs: q/raw/, qq{interpolating}, Q[literal].
        # A bracket can be repeated to make a longer delimiter (q<< >>);
        # other characters can not, so qq|| is an empty string.
        # and heredocs (q:to/END/). Before the keyword and builtin rules,
        # which would otherwise take q for a word. With a parenthesis right
        # after it, q is a routine that is being called: q(1)
        rule %r/#{quote_start}(qq|q|Q)(ww|[a-zA-Z])?(?!\()(?:(#{adverbs})\p{Space}*|#{before_delimiter})((#{OPEN_BRACKET})\5*|#{quote_delimiter.(3)})/ do |m|
          opening = m[0]
          adverbs = m[3].to_s
          # qq strings interpolate, and so do the others as far as their
          # adverbs say: q:s/$scalars only/, Qc/{closures} only/
          interpolations = interpolations_of(m[1], m[2], adverbs)
          # nothing is special in Q, not even a backslash: Q/\/
          body, closing = scan_delimited(m, m[4], escapes: m[1] != 'Q')

          if adverbs.match?(HEREDOC_ADVERB)
            token Str, opening + body + closing
            lex_heredocs(m, body, interpolations)
          elsif interpolations.empty?
            token Str, opening + body + closing
          else
            token Str, opening
            lex_quoted(body, interpolations)
            token Str, closing
          end
        end

        # --- regexes: m/x/, rx{x}, and with adverbs m:i/x/
        rule %r/#{quote_start}(?:m|ms|rx)(?!\()(?:(#{adverbs})\p{Space}*|#{before_delimiter})((#{OPEN_BRACKET})\3*|#{quote_delimiter.(1)})/ do |m|
          opener = m[2]
          token Str::Regex
          lex_regex_part(m, opener, :regex_body)
        end
        # substitution and transliteration: s/a/b/, S{a}{b}, s:2nd/a/b/, tr/a-z/A-Z/
        # (a pattern can not be empty, so S|| and S%% are operators, and so
        # is S!~~)
        rule %r/#{quote_start}(ss|s|SS|S|tr|TR)(?=\p{Space}*:!?[#{w}])\p{Space}*(?::!?[#{w}\-]+(?:\([^)\n]*\))?\p{Space}*)+((#{OPEN_BRACKET})\3*|[^#{w}:\p{Space}$@%&=,;)])/ do |m|
          lex_substitution(m, m[0], m[1], m[2])
        end
        rule %r/#{quote_start}(ss|s|SS|S|tr|TR)(?!!~~|\()#{before_delimiter}(([{(\[])\3*|([\/|!^~@%])(?!\4))/ do |m|
          opening, kind, opener = m[0], m[1], m[2]
          if opener.start_with?('[') && !substitution_follows?(m, opener)
            # an index into something called s: s[0]
            token Name, kind
            token Text::Whitespace, opening[kind.length...-opener.length]
            token Punctuation, opener
          else
            lex_substitution(m, opening, kind, opener)
          end
        end
        # --- curly and corner quotes: ‘raw’ (or ‚this‘, or ’this‘),
        # “interpolating” (or „this“, or ”this“), ｢no escapes｣
        rule %r/[‘‚’][^‘’]*[’‘]/, Str::Single
        rule %r/｢[^｣]*｣/, Str
        rule %r/[“„”]/, Str::Double, :dq_curly

        # --- names whose meaning depends on where they are
        # method calls: .say, .Int, .^name, .?foo
        rule %r/#{after_dot}#{word_match.(method_builtins)}/, Name::Builtin
        rule %r/#{after_dot}#{ident}/, Name::Function
        # the key of a pair is a plain word, whatever it spells: name => 1
        # (but Z=> between two terms is the zip operator)
        rule %r/(?<!#{ident_char})(?![RXZ]=>(?<=\p{Space}...))#{qualified_ident}(?=\p{Space}*=>)/, Name
        # operators used by name: infix:<+>(1, 2)
        rule %r/(?<!#{ident_char})#{op_categories}#{op_name_suffix}/, Name::Function
        # traits: is rw, is copy, is export
        rule %r/(?<!#{ident_char})(is)(\p{Space}+)#{word_match.(TRAITS)}/ do
          groups Keyword, Text::Whitespace, Keyword
        end
        # phasers as traits: will leave { ... }
        rule %r/(?<!#{ident_char})(will)(\p{Space}+)#{word_match.(WILL_TRAITS)}/ do
          groups Keyword, Text::Whitespace, Keyword
        end
        # user-defined types: "is Foo", "of Foo", "--> Foo"
        rule %r/(?<!#{ident_char})(is|does|of|returns|handles|trusts|hides)(\p{Space}+)#{not_a_builtin_type}(#{type_name}#{smiley}?)(?!#{ident_end})/ do
          groups Keyword, Text::Whitespace, Name::Class
        end
        rule %r/(-->)(\p{Space}*)#{not_a_builtin_type}(#{type_name}#{smiley}?)(?!#{ident_end})/ do
          groups Operator, Text::Whitespace, Name::Class
        end
        # version literals: use v6.d; use v6.e.PREVIEW; use v6.d+;
        rule %r/#{nw}(use|need|require)(\p{Space}+)(v\p{Nd}+(?:\.(?:\p{Nd}+|\*|[A-Za-z]+))*\+?)(?![#{w}'\-])/ do
          groups Keyword::Namespace, Text::Whitespace, Num
        end
        # module names: use Foo::Bar; need Baz; (pragmas such as 'use lib' too)
        rule %r/#{nw}(use|need|require|import|no)(\p{Space}+)(#{qualified_ident})(?!#{ident_end})/ do
          groups Keyword::Namespace, Text::Whitespace, Name::Namespace
        end

        # --- declarations
        rule %r/#{word_match.(%w(class role grammar module package knowhow enum subset))}(\p{Space}+)(#{qualified_ident})/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Class
        end
        rule %r/#{word_match.(%w(sub method submethod macro))}(\p{Space}+)(#{routine_name})/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
        end
        # "sub" is optional after multi, proto and only: multi foo(Int $x) { }
        rule %r/#{word_match.(%w(multi proto only))}(\p{Space}+)(?!(?:sub|method|submethod|token|rule|regex|macro)(?!#{ident_end}))(#{routine_name})(?=\p{Space}*[({])/ do
          groups Keyword::Declaration, Text::Whitespace, Name::Function
        end

        # --- keywords and other reserved words
        # the label of the loop to leave or to go on with: next OUTER
        rule %r/#{word_match.(%w(next last redo))}(\p{Space}+)([A-Z][A-Z0-9_]*)(?=\p{Space}*(?:[;}]|if|unless|when|$))/ do
          groups Keyword, Text::Whitespace, Name::Label
        end
        rule %r/#{word_match.(DECLARATORS)}/, Keyword::Declaration
        rule %r/#{word_match.(NAMESPACE_KEYWORDS)}/, Keyword::Namespace
        rule %r/#{word_match.(KEYWORDS)}/, Keyword
        rule %r/#{word_match.(%w(True False Nil))}/, Keyword::Constant
        rule %r/#{word_match.(%w(self))}/, Name::Builtin::Pseudo
        rule %r/#{word_match.(CONSTANTS)}/, Name::Constant
        rule %r/[∞∅]/, Name::Constant
        # version literals: v6.d, v1.2.3, v1.2+, v6.e.PREVIEW
        rule %r/(?<!#{ident_char})v\p{Nd}+(?:\.(?:\p{Nd}+|\*|[a-z]|[A-Z]+)(?!#{ident_end}))*\+?(?!#{ident_end})/, Num
        # meta operators: Z+, X~, R-, Z=>, Rcmp, S!~~, and x=, xx=
        rule %r/#{nw}S(?:!~~|~~|&&|\|\||\^\^|%%|\/\/|==|!=|&(?=\p{Space})|xx?(?![#{w}'\-]))/, Operator
        rule %r/#{nw}[RXZ](?:!~~|\*\*|\/\/|&&|\|\||<=>|=>|==|!=|<=|>=|~~|[-+*\/%~,&|^?<>]|(?:cmp|eq|ne|lt|gt|le|ge|leg|eqv|min|max|div|mod|and|or|xor|x|xx)(?![#{w}'\-]))/, Operator
        rule %r/#{nw}(?:xx?|min|max)=(?![=~>])/, Operator
        rule %r/#{word_match.(WORD_OPERATORS, '(?!\()')}/, Operator::Word

        # --- types and routines that come with the language
        # exception and AST class families: X::AdHoc, CX::Done, RakuAST::Name...
        rule %r/(?<![#{w}':\-])(?:X|CX|RakuAST)(?:::[A-Za-z][#{w}'\-]*)+#{smiley}?(?![#{w}'\-])/, Keyword::Type
        rule %r/#{word_match.(BUILTIN_CLASSES, "#{smiley}?")}/, Keyword::Type
        rule %r/#{word_match.(BUILTINS)}/, Name::Builtin
        # a user-defined type: with a smiley, or constraining a variable
        rule %r/(?<!#{ident_char})#{type_name}#{smiley}/, Name::Class
        rule %r/(?<!#{ident_char})#{type_name}(?=\p{Space}+[$@%&\\])/, Name::Class
        rule %r/(?<=[#{w}>])#{smiley}/, Keyword::Type

        # --- operators that could be mistaken for quotes
        # hyper operators: »+«, >>+<<, +« (prefix), »++ and ».say (postfix)
        rule %r/(?:«|»|<<|>>)[-+*\/%~=!&|^?<>]+(?:«|»|<<|>>)/, Operator
        rule %r/[-+*\/%~!?|^]+«/, Operator
        # an ASCII prefix hyper, when its operand follows: -<< (3, 2, 1)
        rule %r/[-+~!?|^]<<(?=\p{Space}*[$@%(\[<])/, Operator
        # ... and around a bracketed operator: «[op]«, <<[op]>>. With a
        # variable inside it is a subscript: @rows>>[$i]>>.chars
        rule %r/(?:«|»|<<|>>)\[[^\]\n$@%]+\](?:«|»|<<|>>)/, Operator
        rule %r/(?:»|>>)(?=\.[#{w}^?!(]|\+\+|--|[\[{<(])/, Operator
        # reduction operators: [+], [\*], [<=], [max], [Z+]
        rule %r/(?<![#{w}\])}>'\-])\[\\?(?:[RXZ]?[-+*\/%~=<>!&|^?,]+|[RXZ]?(?:min|max|gcd|lcm|and|or|xor|x|xx|cmp|eq|ne|lt|gt|le|ge|leg|eqv))\]/, Operator
        # quote-like words with interpolation: «a $b» and <<a $b>>. After
        # an operator or a term these are hyper operators, not quotes,
        # and so they are in [«] and [<<], which name an operator.
        rule %r/(?<![#{w}\])}>+\-*\/%~!?^|&.])«(?!\])/, Str::Double, :ww_guillemets
        rule %r/(?<![#{w}\])}>])<<(?![=\]])/, Str::Double, :ww_angles
        rule %r/(?!<->)<(?:\\[<>]|[^\p{Space}=<>{};()])(?:(?:\\[<>]|[^<>{};()])*(?:\\[<>]|[^\p{Space}<>{};()]))?>/, Str

        # --- labels, pairs and operators
        # loop labels: OUTER: for ...
        rule %r/#{nw}([A-Z][A-Z0-9_]*)(:)(?=\p{Space}*(?:for|while|until|loop|repeat|given|if|unless|do|\{|$))/ do
          groups Name::Label, Punctuation
        end
        # colon-pairs and adverbs: :name, :!flag, :name(...), :2nd
        rule %r/(:!?)(#{ident})/ do
          groups Punctuation, Name::Attribute
        end
        rule %r/(:)(\p{Nd}+)(#{ident})/ do
          groups Punctuation, Num::Integer, Name::Attribute
        end
        # superscript exponents: $x², A⁻¹
        rule %r/[#{sup}]+/, Operator
        # a prefix operator in front of a function reference: ~&foo, +&bar
        rule %r/[-~+?!|^](?=&[\p{L}\p{No}\p{Nl}_])/, Operator
        # assignment meta operators: +=, //=, ||=, ...
        rule %r/(?:\*\*|\/\/|\|\||&&|%%|[-+*\/%~|&^?])=(?![=~>])/, Operator
        rule %r/#{any_of.(SYMBOL_OPERATORS)}/, Operator
        # A name right before a parenthesis is a call: squared(2). Unless
        # it is capitalized, as types are, which can be called to coerce:
        # Foo($x)
        rule %r/#{qualified_ident}(?=\()/ do |m|
          token m[0].match?(/(?:\A|::)\p{Lu}[^:]*\z/) ? Name : Name::Function
        end
        rule %r/#{qualified_ident}/, Name
        rule %r/'(?:\\\\|\\[^\\]|[^'\\])*'/, Str::Single
        rule %r/"/, Str::Double, :dq_string
        rule %r/[:\[]/, Punctuation
      end

      state :root do
        mixin :common
        rule %r/[{}]/, Punctuation
        # anything else that is not a letter: user-defined operators, ...
        rule %r/[^#{w}\p{Space}]/, Operator
        rule %r/./m, Text
      end

      # between "token name" and the block that holds its body
      state :pre_token do
        # a statement that ends before any block was not a declaration
        rule %r/;/, Punctuation, :pop!
        mixin :common
        rule %r/\{/ do
          token Punctuation
          goto :token
        end
        rule %r/[^#{w}\p{Space}]/, Operator
        rule %r/./m, Text
      end

      # the bracketed part of a name: token infix:sym<+> { ... }
      state :token_sym_brackets do
        rule %r/(#{OPEN_BRACKET})\1*/ do |m|
          opening = m[0]
          token Name, opening + scan_delimited(m, opening).join
          goto :pre_token
        end
        rule(//) { goto :pre_token }
      end

      state :token do
        rule %r/\}/, Punctuation, :pop!
        mixin :regex_body
      end

      # the body of a token, rule or regex, or of a m//, rx// or s///
      # pattern
      state :regex_body do
        rule %r/\p{Space}+/, Text::Whitespace
        rule %r/#.*/, Comment::Single
        # :my $x = ...; declarations are ordinary code
        rule %r/:(?=(?:my|our|state|constant|temp|let)\b)/, Punctuation
        rule %r/(?<=:)(?:my|our|state|constant|temp|let).*?;/m do |m|
          sublex m[0]
        end
        # adverbs: :i, :sigspace, :!ratchet, :Perl5(...)
        rule %r/(:!?)([A-Za-z][#{w}\-]*)/ do
          groups Punctuation, Name::Attribute
        end
        # character classes: <[a..z]>, <-[\p{Nd}] + [_]>
        rule %r/<(?:[-+!?.]\p{Space}*)?\[(?:\\.|[^\]\\])*\](?:\p{Space}*[-+]\p{Space}*(?:\[(?:\\.|[^\]\\])*\]|:?[#{w}\-]+))*\p{Space}*>/m, Str::Regex
        # unicode properties: <:Lu>, <+:L>, <:L + :N>, <:L - [a]>
        rule %r/<[-+!?.]?\p{Space}*:[#{w}\-]+(?:\([^)\n]*\))?(?:\p{Space}*[-+]\p{Space}*(?::[#{w}\-]+|\[(?:\\.|[^\]\\])*\]))*\p{Space}*>/m, Name::Builtin
        # named assertions: <foo>, <.foo>, <?before ...>, <name=rule>
        rule %r/(<)([?!.+-]?)(\p{Space}*)(#{ident})(=)(#{ident})(>)/ do
          groups Punctuation, Punctuation, Text::Whitespace, Name::Variable,
                 Operator, Name::Function, Punctuation
        end
        rule %r/(<)([?!.+-]?)(\p{Space}*)#{word_match.(REGEX_BUILTINS)}(>)?/ do
          groups Punctuation, Punctuation, Text::Whitespace, Name::Builtin, Punctuation
        end
        rule %r/(<)([?!.+-]?)(\p{Space}*)(#{ident})(>)?/ do
          groups Punctuation, Punctuation, Text::Whitespace, Name::Function, Punctuation
        end
        # code blocks and variables
        rule %r/\{/ do
          token Punctuation
          @brace_levels << 1
          push :embedded
        end
        rule %r/\$<[#{w}'\-]+>/, Name::Variable
        rule %r/\$\p{Nd}+/, Name::Variable
        rule %r/[$@][.^:?=!~*]?#{qualified_ident}#{angle_subscripts}/, Name::Variable
        # literals
        rule %r/'(?:\\.|[^'\\])*'/m, Str::Single
        rule %r/[‘‚’][^‘’\n]*[’‘]/, Str::Single
        rule %r/｢[^｣]*｣/, Str
        rule %r/"/, Str::Double, :dq_string
        rule %r/[“„”]/, Str::Double, :dq_curly
        rule %r/\\[xXcCoO]\[[^\]\n]*\]|\\x[0-9a-fA-F]+|\\./m, Str::Escape
        # anchors, quantifiers, alternation, separators
        rule %r/\^\^|\$\$|<<|>>|«|»|\^|\$/, Operator
        rule %r/\*\*|\|\||&&|%%|\.\.\.?|::?:?|[|&*+?!%~=.]/, Operator
        rule %r/[()\[\]<>]/, Punctuation
        rule %r/\}/, Punctuation
        rule %r/[#{w}]+/, Str::Regex
        rule %r/./m, Str::Regex
      end

      # Code embedded in something else (a closure inside a string, or code
      # inside a regex) is
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
        rule %r/[^#{w}\p{Space}]/, Operator
        rule %r/./m, Text
      end

      # Pod documentation blocks
      state :pod_body do
        # Blocks whose content is taken as it is: a "=begin" inside one
        # does not open a block, and the "=end" has to be indented like
        # the "=begin", so that an indented example does not end it.
        rule %r/^([ \t]*)(=begin)([ \t]+)(code|comment|input|output|data)(?![#{w}\-])([^\n]*\n)(.*?)(?=^\1=end[ \t]+\4(?![#{w}\-]))/m do |m|
          lex_pod_verbatim(m[4], m[5], m[6], [m[1], m[2], m[3]])
        end
        # the same as a paragraph, which ends at a blank line or at the
        # next directive, and abbreviated: =code say 1;
        rule %r/^([ \t]*)(=for)([ \t]+)(code)(?![#{w}\-])([^\n]*\n?)(#{pod_paragraph})/ do |m|
          lex_pod_verbatim(m[4], m[5], m[6], [m[1], m[2], m[3]])
        end
        rule %r/^([ \t]*)(=code)(?![#{w}\-])([ \t]*)(#{pod_paragraph})/ do |m|
          code = m[4]
          token Text::Whitespace, m[1]
          token Comment::Preproc, m[2]
          token Text::Whitespace, m[3]
          sublex code
        end

        rule %r/^([ \t]*)(=head\p{Nd}*)(.*)/ do
          groups Text::Whitespace, Comment::Preproc, Generic::Heading
        end
        rule %r/^([ \t]*)(=(?:begin|for))([ \t]*)([#{w}\-]*)/ do
          groups Text::Whitespace, Comment::Preproc, Text::Whitespace, Name::Namespace
          push :pod_config
        end
        rule %r/^([ \t]*)(=(?:end|finish))([ \t]*)([#{w}\-]*)/ do
          groups Text::Whitespace, Comment::Preproc, Text::Whitespace, Name::Namespace
        end
        rule %r/^([ \t]*)(=[A-Za-z][#{w}]*)/ do
          groups Text::Whitespace, Comment::Preproc
        end
        mixin :pod_format_start
        rule %r/[^\n]+?(?=[A-Z][<«]|$)/, Comment::Multiline
        rule %r/[A-Z]/, Comment::Multiline
        rule %r/\n/, Text::Whitespace
      end

      # the options of a directive: :kind<Type>, :caption("x"), :!numbered
      state :pod_config_pairs do
        rule %r/[ \t]+/, Text::Whitespace
        rule %r/(:!?)([#{w}\-]+)(<[^>\n]*>|\([^)\n]*\)|\[[^\]\n]*\]|\{[^}\n]*\}|«[^»\n]*»)?/ do
          groups Punctuation, Name::Attribute, Str
        end
      end

      state :pod_config do
        mixin :pod_config_pairs
        rule(//) { pop! }
      end

      # the rest of the line that opens a block
      state :pod_config_line do
        mixin :pod_config_pairs
        rule %r/[^\n]+/, Comment::Multiline
        rule %r/\n/, Text::Whitespace
      end

      # formatting codes: B<bold>, I<italic>, C<code>, L<link>, ... with
      # their other delimiters, C<< a > b >> and C«a > b»
      state :pod_format_start do
        rule %r/([A-Z])(<<|<|«)/ do |m|
          open_pod_format(m[1], m[2])
        end
      end

      # The text of a formatting code. The codes nest, and one that is not
      # closed stops at the end of its paragraph.
      state :pod_format do
        rule %r/\n(?=[ \t]*(?:\n|\z|=[A-Za-z]))/ do
          token Text::Whitespace
          pop!(@pod_formats.length)
          @pod_formats.clear
        end
        rule %r/\n/, Text::Whitespace
        mixin :pod_format_start
        # angle brackets are counted, and so the first ">" does not close
        # C<%h<key>>; with the other delimiters they are plain text
        rule %r/</ do
          closer, text, = @pod_formats.last
          @pod_formats.last[2] += 1 if closer == '>'
          token text
        end
        rule %r/[>»]/ do |m|
          bracket = m[0]
          closer, text, depth = @pod_formats.last
          if closer == '>' && bracket == '>' && depth.positive?
            @pod_formats.last[2] -= 1
            token text, bracket
          elsif closer == bracket || (closer == '>>' && bracket == '>' && m.scan(/>/))
            token Punctuation, closer
            @pod_formats.pop
            pop!
          else
            token text, bracket
          end
        end
        rule %r/[^<>«»\nA-Z]+|[A-Z«]/ do
          token @pod_formats.last[1]
        end
      end

      # what can appear inside an interpolating string
      state :interpolation do
        rule %r/\\(?:[abefnrt0"'\\$@%&{}<>«»]|[xXoOcCdD]\[[^\]\n]*\]|x[0-9a-fA-F]+)/ do
          token interpolates?(:b) ? Str::Escape : Str::Double
        end
        rule %r/\\./m, Str::Double
        # What interpolates is code, and is lexed as code, so that a
        # variable looks the same inside a string as outside of it.
        # - contextualizers: $(...), @(...)
        # - scalars: $x
        # - arrays and hashes only if something in brackets or parentheses
        #   follows: @a[0], %h<a>, @a.elems()
        # - functions only if they are called: &f()
        # Each can be followed by subscripts and by method calls, which
        # need their parentheses here: $x[0]<a>, $x.uc(), @a.sort().join(',')
        rule %r/(?:[$@%&]#{arguments}#{postfix}*|\$(?:[*.!^?=~:]?#{qualified_ident}|[!\/&¢]|\p{Nd}+|<[^>\n]+>)#{postfix}*|[@%][*.!^?=~:]?#{qualified_ident}#{postfix}+|&#{ident}#{arguments}#{postfix}*)/ do |m|
          if interpolates?(SIGIL_INTERPOLATIONS[m[0][0]])
            sublex m[0]
          else
            token Str::Double
          end
        end
        rule %r/\{/ do
          if interpolates?(:c)
            token Punctuation
            @brace_levels << 1
            push :embedded
          else
            token Str::Double
          end
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
        # a word can not start with "#": it starts a comment
        rule %r/(?<=\p{Space})#.*/, Comment::Single
        mixin :interpolation
        rule %r/[^»\\$@%&{#]+/, Str::Double
        rule %r/[$@%&\\#]/, Str::Double
      end

      state :ww_angles do
        rule %r/>>/, Str::Double, :pop!
        rule %r/(?<=\p{Space})#.*/, Comment::Single
        mixin :interpolation
        rule %r/[^>\\$@%&{#]+/, Str::Double
        # (a lone '>' does not close the quote)
        rule %r/[$@%&\\>#]/, Str::Double
      end
    end
  end
end
