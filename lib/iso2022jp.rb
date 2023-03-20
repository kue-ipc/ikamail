# libary for ISO-2022-JP (JIS code)

# NKFではなくRuby本体のEncodingを使用する
# 全角チルダと全角マイナスの扱いの違いに注意すること

module Iso2022jp
  # EUC-JPに変化された文字が来る場合があるため、UTF-8にしてから処理すること
  FB_PROCS = {
    skip: ->(_) { '' },
    html: ->(c) { '&#%d;' % c.encode(Encoding::UTF_8).ord },
    xml: ->(c) { '&#x%X;' % c.encode(Encoding::UTF_8).ord },
    perl: ->(c) { '\\x{%X}' % c.encode(Encoding::UTF_8).ord },
    java: ->(c) { c.encode(Encoding::UTF_16LE).unpack('v*').map { |n| '\\u%04X' % n }.join },
    subchar: ->(_) { '?' },
  }

  module_function # rubocop:disable Style/AccessModifierDeclarations

  def check_unconvertible_chars(str, strict: true)
    no_amp_str = str.gsub('&', '&amp;')
    conv_str = double_conv_jis(no_amp_str, fallback: :xml, cp932: !strict)

    conv_str.scan(/&\#x(\h{1,6});/).map { |m| m[0].to_i(16).chr(Encoding::UTF_8) }
  end

  # fallback: 存在しない場合
  # cp932: CP932で拡張された文字を含める (CP50220 or CP50221)
  # x0201: JIS X 0201(半角カタカナ) を JIS X 0208(全角カタカナ) に変換する
  def double_conv_jis(str, fallback: :skip, cp932: true, x0201: true)
    str = str.dup
    fb_proc = FB_PROCS[fallback]
    raise ArgumentError, 'invalid fallback' unless fb_proc

    encode =
      if cp932
        # マイナス -> 全角マイナス
        # 波ダッシュ -> 全角チルダ
        str.tr!("\u2212\u301C", "\uFF0D\uFF5E")
        if x0201
          # 半角カタカナを全角カタカナに変換する
          Encoding::CP50220
        else
          # mail-iso-2022-jp が使用するエンコードと同じ
          Encoding::CP50221
        end
      else
        str.tr!("\uFF0D\uFF5E", "\u2212\u301C")
        str.gsub!(/[\uFF61-\uFF9F]+/) { |s| s.unicode_normalize(:nfkc) } if x0201
        Encoding::ISO_2022_JP
      end
    str.encode(encode, Encoding::UTF_8, fallback: fb_proc).encode(Encoding::UTF_8)
  end
end
