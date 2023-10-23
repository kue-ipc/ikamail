# 日本語におけるワードラップや禁則処理を行う
# 参考文献
# * JIS X 4051
# * 日本語組版処理の要件 (日本語版) https://www.w3.org/TR/jlreq/
# ワードラップも行うが、JISであることを前提とし、厳密性にはかける。
# 割注始め括弧類や割注終わり括弧類は、それぞれの括弧類に含まれる。
# JIS X 4051 / 日本語組版処理の要件 との違い
# * 濁音・半濁音を行頭禁止文字に含める。
# * 合字である「ㇷ゚ U+31F7 U+309A」を考慮しないが、実質行頭禁止になる。

require "set"

module JapaneseWrap
  module_function # rubocop:disable Style/AccessModifierDeclarations

  # rubocop: disable Style/PercentLiteralDelimiters
  # 始め括弧類
  OPENING_BRACKETS = %w!‘ “ ( 〔 [ { 〈 《 「 『 【 ⦅ 〘 〖 « 〝!.freeze
  OPENING_BRACKETS_FULLWIDTH = %w!（ ［ ｛ ｟!.freeze
  OPENING_BRACKETS_HALFWIDTH = %w!｢!.freeze

  # 終わり括弧類
  CLOSING_BRACKETS = %w!’ ” ) 〕 ] } 〉 》 」 』 】 ⦆ 〙 〗 » 〟!.freeze
  CLOSING_BRACKETS_FULLWIDTH = %w!） ］ ｝ ｠!.freeze
  CLOSING_BRACKETS_HALFWIDTH = %w!｣!.freeze
  # rubocop: enable Style/PercentLiteralDelimiters

  # ハイフン類
  HYPHENS = %w[‐ 〜 ゠ –].freeze

  # 区切り約物
  DIVIDING_PUNCTUATION_MARKS = %w[! ? ‼ ⁇ ⁈ ⁉].freeze
  DIVIDING_PUNCTUATION_MARKS_FULLWIDTH = %w[！ ？].freeze

  # 中点類
  MIDDLE_DOTS = %w[・ : ;].freeze
  MIDDLE_DOTS_FULLWIDTH = %w[： ；].freeze
  MIDDLE_DOTS_HALFWIDTH = %w[･].freeze

  # 句点類
  FULL_STOPS = %w[。 .].freeze
  FULL_STOPS_FULLWIDTH = %w[．].freeze
  FULL_STOPS_HALFWIDTH = %w[｡].freeze

  # 読点類
  COMMAS = %w[、 ,].freeze
  COMMAS_FULLWIDTH = %w[，].freeze
  COMMAS_HALFWIDTH = %w[､].freeze

  # 繰返し記号
  ITERATION_MARKS = %w[ヽ ヾ ゝ ゞ 々 〻].freeze

  # 長音記号
  PROLONGED_SOUND_MARK = %w[ー].freeze
  PROLONGED_SOUND_MARK_HALFWIDTH = %w[ｰ].freeze

  # 小書きの仮名
  SMALL_KANA = %w[
    ぁ ぃ ぅ ぇ ぉ
    ァ ィ ゥ ェ ォ
    っ ゃ ゅ ょ ゎ ゕ ゖ
    ッ ャ ュ ョ ヮ ヵ ヶ ㇰ
    ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ
    ㇻ ㇼ ㇽ ㇾ ㇿ
  ].freeze
  SMALL_KANA_HALFWIDTH = %w[
    ｧ ｨ ｩ ｪ ｫ
    ｯ ｬ ｭ ｮ
  ].freeze
  # ㇷ゚ U+31F7 U+309A

  # 濁点・半濁点
  SOUND_MARKS = (%w[゛ ゜] + ["\u3099", "\u309A"]).freeze
  SOUND_MARKS_HALFWIDTH = ["\uFF9E", "\uFF9F"].freeze

  # 分離禁止文字列
  INSEPARABLE_STRS = %w[
    ——
    ……
    ‥‥
    〳〵
    〴〵
  ].freeze

  NOT_STARTING_CHARS = Set.new([
    *CLOSING_BRACKETS,
    *CLOSING_BRACKETS_FULLWIDTH,
    *CLOSING_BRACKETS_HALFWIDTH,
    *HYPHENS,
    *DIVIDING_PUNCTUATION_MARKS,
    *DIVIDING_PUNCTUATION_MARKS_FULLWIDTH,
    *MIDDLE_DOTS,
    *MIDDLE_DOTS_FULLWIDTH,
    *MIDDLE_DOTS_HALFWIDTH,
    *FULL_STOPS,
    *FULL_STOPS_FULLWIDTH,
    *FULL_STOPS_HALFWIDTH,
    *COMMAS,
    *COMMAS_FULLWIDTH,
    *COMMAS_HALFWIDTH,
    *ITERATION_MARKS,
    *PROLONGED_SOUND_MARK,
    *PROLONGED_SOUND_MARK_HALFWIDTH,
    *SMALL_KANA,
    *SMALL_KANA_HALFWIDTH,
    *SOUND_MARKS,
    *SOUND_MARKS_HALFWIDTH,
  ]).freeze

  NOT_ENDING_CHARS = Set.new([
    *OPENING_BRACKETS,
    *OPENING_BRACKETS_FULLWIDTH,
    *OPENING_BRACKETS_HALFWIDTH,
  ]).freeze

  HANGING_CHARS = Set.new([
    *FULL_STOPS,
    *FULL_STOPS_FULLWIDTH,
    *FULL_STOPS_HALFWIDTH,
    *COMMAS,
    *COMMAS_FULLWIDTH,
    *COMMAS_HALFWIDTH,
  ]).freeze

  ASCII_CHARS = Set.new("\u0020".."\u007E").freeze

  FULLWIDTH_CHARS = Set.new([*("\uFF01".."\uFF60"), *("\uFFE0".."\uFFE6")])
  HALFWIDTH_CHARS = Set.new([*("\uFF61".."\uFF9F"), *("\uFFE8".."\uFFEE")])

  # 長いテキストを折り返す。
  def text_wrap(str, **opts)
    buff = String.new(encoding: "UTF-8")
    str.each_line do |line|
      each_wrap(line, **opts) do |part|
        buff << part
      end
    end
    buff
  end

  # 折り返しした行をブロックに渡す。ブロックがない場合はEnumeratorを返す。
  # == 引数
  # str:: 折り返す文字列
  # col:: 1行にはいる列の数。つまり、一行の長さ。
  # rule:: 折り返しのルール、:none, :force, :word_wrap, :jisx4051
  # ambiguous:: Unicodeで幅がAmbiguousとなっている文字(ギリシャ文字)の幅
  # hanging:: 句点等のぶら下げを有効にする。
  # word_break:: 改行できる文字、:normal, :keep_all, :break_all, :ascii, :latin
  def each_wrap(str, col: 0, rule: :force, ambiguous: 2, hanging: false, word_break: :normal)
    unless block_given?
      return enum_for(__method__, str, col: col, rule: rule, ambiguous: ambiguous, hanging: hanging,
        word_break: word_break)
    end
    return yield str if !col.positive? || rule == :none
    return yield str if str =~ /^$/

    display_with = Unicode::DisplayWidth.new(ambiguous: ambiguous, emoji: true)
    remnant = str.dup

    until remnant.empty?
      min_ptr = calc_ptr(remnant, col, display_with)
      ptr = search_breakable(remnant, min_ptr, rule: rule, hanging: hanging, word_break: word_break)

      if ptr < remnant.size
        yield "#{remnant[0, ptr].rstrip}\n"
        remnant = remnant[ptr, remnant.size - ptr]
      else
        yield remnant
        break
      end
    end
  end

  # 長さに収まる文字列の位置
  def calc_ptr(str, col, display_with)
    min_ptr = 0
    max_ptr = str.size
    ptr = max_ptr
    width = display_with.of(str)
    while min_ptr < max_ptr
      ptr = if width.zero?
        ptr + 1
      else
        col * ptr / width
      end
      ptr = min_ptr + 1 if ptr <= min_ptr
      ptr = max_ptr if ptr > max_ptr
      width = display_with.of(str[0, ptr])
      if width > col
        max_ptr = ptr - 1
      else
        min_ptr = ptr
      end
    end
    min_ptr
  end

  # 改行可能な場所を探す。
  def search_breakable(str, ptr, rule: :force, hanging: false, word_break: :normal)
    case rule
    when :none, :force
      ptr
    when :word_wrap
      search_breakable_word_wrap(str, ptr, word_break: word_break)
    when :jisx4051
      search_breakable_jisx4051(str, ptr, hanging: hanging, word_break: word_break)
    else
      raise ArgumentError, "unknown rule: #{rule}"
    end
  end

  # 英単語のワードラップ
  def search_breakable_word_wrap(str, ptr, forward: true, word_break: :normal)
    # 続きが空白の場合は、空白が終わりまで前進する
    if forward
      fw_ptr = search_forward_space(str, ptr)
      return fw_ptr if fw_ptr
    end

    # 続きが非単語かつASCIIではない場合は即座に終了
    return ptr if !check_word_char(str[ptr], word_break: word_break) && str[ptr] !~ /[[:ascii:]]/

    # 単語区切りを見つける
    cur_ptr = ptr
    while cur_ptr.positive?
      # 非単語で終わっていれば終了
      return cur_ptr unless check_word_char(str[cur_ptr - 1], word_break: word_break)

      cur_ptr -= 1
    end

    # 区切り場所が見つからない場合は、強制切断
    ptr
  end

  # JIS X 4051に基づく改行
  def search_breakable_jisx4051(str, ptr, hanging: false, word_break: :normal)
    ptr += 1 if hanging && HANGING_CHARS.include?(str[ptr])
    ptr = search_breakable_word_wrap(str, ptr, word_break: word_break)
    cur_ptr = ptr
    while cur_ptr.positive?
      if str[cur_ptr] != " "
        cur_ptr = search_breakable_word_wrap(str, cur_ptr, forward: false, word_break: word_break)
        if NOT_STARTING_CHARS.exclude?(str[cur_ptr]) &&
           NOT_ENDING_CHARS.exclude?(str[cur_ptr - 1])
          return cur_ptr
        end
      end

      cur_ptr -= 1
    end
    ptr
  end

  def search_forward_space(str, ptr)
    return if str[ptr] !~ /\s/

    ptr += 1
    ptr += 1 while str[ptr] =~ /\s/

    ptr
  end

  def check_word_char(chr, word_break: :normal)
    chr =~
      case word_break
      when :normal
        /[[:word:]&&[^\p{Han}\p{Hiragana}\p{Katakana}\p{Hangul}]]/
      when :keep_all
        /[[:word:]]/
      when :break_all
        /./
      when :ascii
        /\w/
      when :latin
        /[[:word:]&&[\p{Latin}]]/
      else
        raise ArgumentError, "unknown word_break: #{word_break}"
      end
  end
end
