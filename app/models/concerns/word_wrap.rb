# frozen_string_literal: true

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
    unless col.positive?
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

      pt = min_pt

      if rule != :force
        # none
      elsif remnant[pt] =~ /\s/
        pt += 1
        while remnant[pt] =~ /\s/
          pt += 1
        end
      else
        while pt > 0
          # 次が空白の場合、空白ではなくなるところまで探す。
          # 禁則処理は無視する

          # 0x2000までを単語構成文字と満たす。全角英字は構成しないとする
          case remnant[pt - 1]
          when /\s/
            # 禁則処理は無視する
            break
          when '-'
            # '-' 区切りはどんな時も改行可能とする
            # 禁則処理は無視する
            break
          when /[\u0020-\u2000]/
            # 単語構成なので次へ
          else
            if rule == :word_wrap
              break
            end

            if !NOT_STARTING_CHARS.include?(remnant[pt]) &&
              !NOT_ENDING_CHARS.include?(remnant[pt - 1])
              break
            end
          end
          pt -= 1
        end
        pt = min_pt unless pt.positive?
      end

      # 左の余白は常に削る。
      yield remnant[0, pt].rstrip + "\n"
      remnant = remnant[pt, remnant.size - pt]
    end

    yield remnant
  end
end
