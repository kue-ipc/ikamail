# 日本語におけるワードラップや禁則処理を行う
# 参考文献
# * JIS X 4051
# * 日本語組版処理の要件 (日本語版) https://www.w3.org/TR/jlreq/
# ワードラップも行うが、JISであることを前提とし、厳密性にはかける。
# 割注始め括弧類や割注終わり括弧類は、それぞれの括弧類に含まれる。
# JIS X 4051 / 日本語組版処理の要件 との違い
# * 濁音・半濁音を行頭禁止文字に含める。
# * 合字である「ㇷ゚ U+31F7 U+309A」を考慮しないが、実質行頭禁止になる。

require 'set'

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
  ]

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
    *SOUND_MARKS_HALFWIDTH
  ]).freeze

  NOT_ENDING_CHARS = Set.new([
    *OPENING_BRACKETS,
    *OPENING_BRACKETS_FULLWIDTH,
    *OPENING_BRACKETS_HALFWIDTH
  ]).freeze

  HANGING_CHARS = Set.new([
    *FULL_STOPS,
    *FULL_STOPS_FULLWIDTH,
    *FULL_STOPS_HALFWIDTH,
    *COMMAS,
    *COMMAS_FULLWIDTH,
    *COMMAS_HALFWIDTH
  ]).freeze

  ASCII_CHARS = Set.new("\u0020".."\u007E").freeze

  FULLWIDTH_CHARS = Set.new([*("\uFF01".."\uFF60"), *("\uFFE0".."\uFFE6")])
  HALFWIDTH_CHARS = Set.new([*("\uFF61".."\uFF9F"), *("\uFFE8".."\uFFEE")])

  def text_wrap(str, **opts)
    buff = String.new(encoding: 'UTF-8')
    str.each_line do |line|
      each_wrap(line, **opts) do |part|
        buff << part
      end
    end
    buff
  end

  def each_wrap(str, col: 0, rule: :force, ambiguous: 2, hanging: false)
    if !col.positive? || rule == :none
      yield str
      return
    end

    display_with = Unicode::DisplayWidth.new(ambiguous: ambiguous, emoji: true)

    remnant = str.dup

    while (width = display_with.of(remnant)) > col
      min_ptr = 0
      max_ptr = remnant.size
      ptr = max_ptr

      while min_ptr < max_ptr
        ptr = col * ptr / width
        ptr = min_ptr + 1 if ptr <= min_ptr
        ptr = max_ptr if ptr > max_ptr
        if (width = display_with.of(remnant[0, ptr])) > col
          max_ptr = ptr - 1
        else
          min_ptr = ptr
        end
      end

      ptr = case rule
            when :force
              min_ptr
            when :word_wrap
              search_breakable_word_wrap(remnant, min_ptr)
            when :jisx4051
              search_breakable_jisx4051(remnant, min_ptr, hanging: hanging)
            else
              logger.error "unknown rule: #{rule}"
              min_ptr
      end

      yield remnant[0, ptr].rstrip
      remnant = remnant[ptr, remnant.size - ptr]

      break if remnant.empty? || remnant == "\n"

      yield "\n"
    end

    yield remnant
  end

  def search_breakable_word_wrap(str, ptr, forward: true)
    # 続きが空白の場合は、空白が終わりまで前進する
    if forward
      fw_ptr = search_forward_space(str, ptr)
      return fw_ptr if fw_ptr
    end

    # 続きが非単語の場合は即座に終了
    return ptr unless check_word_char(str[ptr])

    # 単語区切りを見つける
    cur_ptr = ptr
    while cur_ptr.positive?
      # 非単語で終わっていれば終了
      return cur_ptr unless check_word_char(str[cur_ptr - 1])

      cur_ptr -= 1
    end

    # 区切り場所が見つからない場合は、強制切断
    ptr
  end

  def search_breakable_jisx4051(str, ptr, hanging: false)
    ptr += 1 if hanging && HANGING_CHARS.include?(str[ptr])
    ptr = search_breakable_word_wrap(str, ptr)
    cur_ptr = ptr
    while cur_ptr.positive?
      if str[cur_ptr] != ' '
        cur_ptr = search_breakable_word_wrap(str, cur_ptr, forward: false)
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

  def check_word_char(chr)
    # 非常に簡易的に欧文文字だけを対象とする
    chr =~ /[\u0021-\u2000]/
  end

  # def search_backward_word(str, pt, lb_rule: false)
  #   cur_pt = pt
  #   pre_word = (str[cur_pt] =~ /[\u0020-\u2000]/)
  #   while cur_pt.positive?
  #     case str[cur_pt - 1]
  #     when /\s/, '-'
  #       # 空白の場合は禁則処理を無視して切断
  #       return cur_pt
  #     when '-'
  #       # '-' 区切りは次の文字の禁則だけ考慮
  #       return cur_pt if !lb_rule && NOT_STARTING_CHARS.include?(str[cur_pt])
  #     when /[\u0020-\u2000]/
  #       unless pre_word
  #         return cur_pt if !lb_rule && NOT_STARTING_CHARS.include?(str[cur_pt])
  #       end

  #       pre_word = true
  #     else
  #       if rule == :word_wrap
  #         break
  #       end

  #       if !NOT_STARTING_CHARS.include?(remnant[pt]) &&
  #         !NOT_ENDING_CHARS.include?(remnant[pt - 1])
  #         break
  #       end
  #     end
  #     cur_pt -= 1
  #   end

  #   # 区切り場所が見つからない場合は、強制切断
  #   pt
  # end
end
