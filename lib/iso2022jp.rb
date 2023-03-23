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
  }.freeze

  module_function # rubocop:disable Style/AccessModifierDeclarations

  # 文字列を正規化する
  def normalize(str, x0201: true)
    str = str.dup
    if x0201
      # 半角カタカナを全角カタカナにする
      str.gsub!(/[\uFF61-\uFF9F]+/) { |s| s.unicode_normalize(:nfkc) }
    end
    # 結合文字を通常の文字にする
    str.tr!("\u3099\u309A", "\u309B\u309C")
    # 半角全角にある半角記号を全角文字にする
    str.gsub!(/[\uFFE8-\uFFEE]+/) { |s| s.unicode_normalize(:nfkc) }
    # CJK互換漢字を標準化する
    str.gsub!(/\p{In_CJK_Compatibility_Ideographs}+/) { |s| s.unicode_normalize(:nfkc) }
    # 他の領域にある半角文字を全角文字にする
    str.tr!(
      # ¢£¬‾¦¥₩
      "\u00A2\u00A3\u00AC\u203E\u00A6\u00A5\u20A9",
      # ￠￡￢￣￤￥￦
      "\uFFE0\uFFE1\uFFE2\uFFE3\uFFE4\uFFE5\uFFE6"
    )
    # ￣ をNFKCしたときの文字を全角文字にする。
    str.gsub!("\u0020\u0304", "\uFFE3")
    # マイナス − を 全角ハイフンマイナス － にする
    str.tr!("\u2212", "\uFF0D")
    # 波ダッシュ 〜 を全角チルダ ～ にする
    str.tr!("\u301C", "\uFF5E")
    str
  end

  def check_unconvertible_chars(str, cp932: true)
    no_amp_str = str.gsub('&', '&amp;')
    conv_str = double_conv_jis(no_amp_str, fallback: :xml, cp932: cp932)

    conv_str.scan(/&\#x(\h{1,6});/).map { |m| m[0].to_i(16).chr(Encoding::UTF_8) }
  end

  # fallback: 存在しない場合
  # cp932: CP932で拡張された文字を含める (CP50220 or CP50221)
  # x0201: JIS X 0201(半角カタカナ) を JIS X 0208(全角カタカナ) に変換する
  def double_conv_jis(str, fallback: :skip, cp932: true, x0201: true)
    fb_proc = FB_PROCS[fallback]
    raise ArgumentError, 'invalid fallback' unless fb_proc

    # 標準化
    str = normalize(str, x0201: x0201)
    if cp932
      # 半角全角変換はnormalizeで実施済み
      # 半角カタカナを全角カタカナに変換しない
      # mail-iso-2022-jp が使用するエンコードと同じ
      str.encode(Encoding::CP50221, Encoding::UTF_8, fallback: fb_proc).encode(Encoding::UTF_8)
    else
      str.tr!("\uFF0D", "\u2212")
      # 全角ハイフンマイナス － を マイナス − にする
      str.tr!("\uFF5E", "\u301C")
      # 全角記号の一部を他の領域にある半角文字にする
      str.tr!(
        # ￠￡￢
        "\uFFE0\uFFE1\uFFE2",
        # ¢£¬
        "\u00A2\u00A3\u00AC"
      )
      normalize(str.encode(Encoding::ISO_2022_JP, Encoding::UTF_8, fallback: fb_proc).encode(Encoding::UTF_8))
    end
  end
end
