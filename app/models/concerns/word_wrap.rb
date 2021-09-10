# ワードラップを行うが、JISであることを前提とし、厳密性はかける
# 絵文字とかには未対応

require 'set'

module WordWrap
  extend ActiveSupport::Concern

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
      min_pt = 0
      max_pt = remnant.size
      pt = max_pt

      while min_pt < max_pt
        pt = col * pt / width
        pt = min_pt + 1 if pt <= min_pt
        pt = max_pt if pt > max_pt
        if (width = Unicode::DisplayWidth.of(remnant[0, pt], 2, {}, emoji: true)) > col
          max_pt = pt - 1
        else
          min_pt = pt
        end
      end

      pt = case rule
           when :force
             min_pt
           when :word_wrap
             search_breakable_word_wrap(remnant, min_pt)
           when :jisx4051
             search_breakable_jisx4051(remnant, min_pt)
           else
             logger.error "unknown rule: #{rule}"
             min_pt
           end

      # 左の余白は常に削る。
      yield "#{remnant[0, pt].rstrip}\n"
      remnant = remnant[pt, remnant.size - pt]
    end

    yield remnant
  end

  def search_breakable_word_wrap(str, pt)
    # 続きが空白の場合は、空白が終わりまで
    # わざとスペースを付けているのだから、和文の禁則処理はしない
    fw_pt = search_forward_space(str, pt)
    return fw_pt if fw_pt

    # 続きが非単語の場合は即座に終了
    return pt unless check_word_char(str[pt])

    # 単語区切りを見つける
    cur_pt = pt
    while cur_pt.positive?
      # 非単語で終わっていれば終了
      return cur_pt unless check_word_char(str[cur_pt - 1])

      Rails.logger.debug cur_pt

      cur_pt -= 1
    end

    # 区切り場所が見つからない場合は、強制切断
    pt
  end

  def search_breakable_jisx4051(str, pt)
    cur_pt = pt
    while cur_pt.positive?
      cur_pt = search_breakable_word_wrap(str, cur_pt)
      if NOT_STARTING_CHARS.exclude?(str[cur_pt]) &&
         NOT_ENDING_CHARS.exclude?(str[cur_pt - 1])
        return cur_pt
      end

      cur_pt -= 1
    end
    pt
  end

  def search_forward_space(str, pt)
    return if str[pt] !~ /\s/

    pt += 1
    pt += 1 while str[pt] =~ /\s/

    pt
  end

  def check_word_char(c)
    # 非常に簡易的に欧文文字だけを対象とする
    c =~ /[\u0021-\u2000]/
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
