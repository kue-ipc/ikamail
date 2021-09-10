# 日本語におけるワードラップや禁則処理を行う
# 参考文献
# * JIS X 4051
# * 日本語組版処理の要件 (日本語版) https://www.w3.org/TR/jlreq/
# ワードラップを行うが、JISであることを前提とし、厳密性はかける
# 未対応
# * 絵文字
# * 合字
# 割注始め括弧類や割注終わり括弧類は、それぞれの括弧類に含まれる。

require 'set'

module WordWrap
  extend ActiveSupport::Concern

  # module Character
  #   # 始め括弧類
  #   OPENING_BRACKETS = %w!‘ “ ( 〔 [ { 〈 《 「 『 【 ⦅ 〘 〖 « 〝!.freeze
  #   OPENING_BRACKETS_FULLWIDTH = %w!（ ［ ｛ ｟!

  #   # 終わり括弧類
  #   CLOSING_BRACKETS = %w!’ ” ) 〕 ] } 〉 》 」 』 】 ⦆ 〙 〗 » 〟!.freeze
  #   CLOSING_BRACKETS_FULLWIDTH = %w!） ］ ｝ ｠!

  #   # ハイフン類
  #   HYPHENS = %w[‐ 〜 ゠ –] 

  #   # 区切り約物
  #   DIVIDING_PUNCTUATION_MARKS = %w[! ? ‼ ⁇ ⁈ ⁉]
  #   DIVIDING_PUNCTUATION_MARKS_FULLWIDTH = %w[！ ？]

  #   # 中点類
  #   MIDDLE_DOTS = %w[・ : ;]
  #   MIDDLE_DOTS_FULLWIDTH = %w[： ；]

  #   # 句点類
  #   FULL_STOPS = %w[。 .]
  #   FULL_STOPS_FULLWIDTH = %w[．]

  #   # 読点類
  #   COMMAS = %w[、 ,]
  #   COMMAS_FULLWIDTH = %w[，]

  #   # 繰返し記号
  #   ITERATION_MARKS = %w[
  #     ヽ ヾ ゝ ゞ 々 〻
  #   ]

  #   # 長音記号
  #   PROLONGED_SOUND_MARK = %w[
  #     ー
  #   ]

  #   # 小書きの仮名
  #   Small kana
  #   SMALL_KANA = %w[
  #     ぁ ぃ ぅ ぇ ぉ
  #     ァ ィ ゥ ェ ォ
  #     っ ゃ ゅ ょ ゎ ゕ ゖ
  #     ッ ャ ュ ョ ヮ ヵ ヶ ㇰ
  #     ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ
  #     ㇻ ㇼ ㇽ ㇾ ㇿ
  #   ]
  #   # ㇷ゚ U+31F7 U+309A


  #   NOT_STARTING_CHARS

  #   NOT_ENDING_CHARS
  # end

  NOT_STARTING_CHARS = Set.new(%w[
    ’ ” ） 〕 ］ ｝ 〉 》 」 』 】 ｠ 〙 〗 » 〟
    ‐ 〜 ゠ –
    ！ ？ ‼ ⁇ ⁈ ⁉
    ・ ： ；
    。 ．
    、 ，
    ヽ ヾ ゝ ゞ 々 〻
    ー
    ぁ ぃ ぅ ぇ ぉ
    っ ゃ ゅ ょ ゎ ゕ ゖ
    ァ ィ ゥ ェ ォ
    ッ ャ ュ ョ ヮ ヵ ヶ ㇰ
    ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ
    ㇻ ㇼ ㇽ ㇾ ㇿ
  ])

  NOT_ENDING_CHARS = Set.new(%w[
    ‘ “ （ 〔 ［ ｛ 〈 《 「 『 【 ｟ 〘 〖 « 〝
  ])

  def word_wrap(str, col: 0, **opts)
    return str unless col.positive?

    buff = String.new
    str.each_line do |line|
      each_wrap(line, col: col, **opts) do |part|
        buff << part
      end
    end
    buff
  end

  def each_wrap(str, col: 0, rule: :force)
    if !col.positive? || rule == :none
      yield str
      return
    end

    remnant = str.dup

    while (width = Unicode::DisplayWidth.of(remnant, 2, {}, emoji: true)) > col
      min_ptr = 0
      max_ptr = remnant.size
      ptr = max_ptr

      while min_ptr < max_ptr
        ptr = col * ptr / width
        ptr = min_ptr + 1 if ptr <= min_ptr
        ptr = max_ptr if ptr > max_ptr
        if (width = Unicode::DisplayWidth.of(remnant[0, ptr], 2, {}, emoji: true)) > col
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
             search_breakable_jisx4051(remnant, min_ptr)
           else
             logger.error "unknown rule: #{rule}"
             min_ptr
      end

      # 左の余白は常に削る。
      yield "#{remnant[0, ptr].rstrip}\n"
      remnant = remnant[ptr, remnant.size - ptr]
    end

    yield remnant
  end

  def search_breakable_word_wrap(str, ptr)
    # 続きが空白の場合は、空白が終わりまで
    # わざとスペースを付けているのだから、和文の禁則処理はしない
    fw_ptr = search_forward_space(str, ptr)
    return fw_ptr if fw_ptr

    # 続きが非単語の場合は即座に終了
    return ptr unless check_word_char(str[ptr])

    # 単語区切りを見つける
    cur_ptr = ptr
    while cur_ptr.positive?
      # 非単語で終わっていれば終了
      return cur_ptr unless check_word_char(str[cur_ptr - 1])

      Rails.logger.debug cur_ptr

      cur_ptr -= 1
    end

    # 区切り場所が見つからない場合は、強制切断
    ptr
  end

  def search_breakable_jisx4051(str, ptr)
    cur_ptr = ptr
    while cur_ptr.positive?
      cur_ptr = search_breakable_word_wrap(str, cur_ptr)
      if NOT_STARTING_CHARS.exclude?(str[cur_ptr]) &&
         NOT_ENDING_CHARS.exclude?(str[cur_ptr - 1])
        return cur_ptr
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
