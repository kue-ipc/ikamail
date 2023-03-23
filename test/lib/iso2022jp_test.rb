require 'test_helper'
require 'iso2022jp'

class Iso2022jpTest < ActiveSupport::TestCase
  ASCII_TEXT = (0x20..0x7F).map { |n| n.chr(Encoding::UTF_8) }.join
  ZEN_TEXT = (0xFF01..0xFF60).map { |n| n.chr(Encoding::UTF_8) }.join
  HAN_TEXT = (0xFF61..0xFF9F).map { |n| n.chr(Encoding::UTF_8) }.join
  ZEN2_TEXT = (0xFFE0..0xFFE6).map { |n| n.chr(Encoding::UTF_8) }.join
  HAN2_TEXT = (0xFFE8..0xFFEE).map { |n| n.chr(Encoding::UTF_8) }.join

  ZEN_TEXT_HAN = ZEN_TEXT.unicode_normalize(:nfkc)
  HAN_TEXT_ZEN = HAN_TEXT.unicode_normalize(:nfkc).tr("\u3099\u309A", "\u309B\u309C")
  ZEN2_TEXT_HAN = ZEN2_TEXT.unicode_normalize(:nfkc)
  HAN2_TEXT_ZEN = HAN2_TEXT.unicode_normalize(:nfkc)

  HAN_KATKANA = 'ｱｶｻﾀﾅﾊﾏﾔﾗﾜｶﾞｻﾞﾀﾞﾊﾞﾊﾟｳﾞﾝ'
  ZEN_KATKANA = 'アカサタナハマヤラワガザダバパヴン'

  WAVE_DASH = "\u301C"
  FULLWIDTH_TILDE = "\uFF5E"
  MINUS = "\u2212"
  FULLWIDTH_HYPHEN_MINUS = "\uFF0D"

  SAMPLE_TEXT = <<~TEXT
    !aAあア亜！ａＡ
  TEXT

  # def cp932ext
  #   [
  #     (0x8740..0x875D),
  #     (0x875F..0x8775),
  #     [0x877E],
  #     (0x8780..0x878F),
  #     (0x8790..0x879C),
  #     (0xFA40..0xFA7E),
  #     (0xFA80..0xFAFC),
  #     (0xFB40..0xFB7E),
  #     (0xFB80..0xFBFC),
  #     (0xFC40..0xFC4B)
  #   ].flat_map(&:to_a).reject do |n|
  #     c = n.chr(Encoding::CP932).encode(Encoding::UTF_8)
  #     if c.encode(Encoding::CP932).ord != n
  #       puts 'OM 0x%04X U+%04X: %c' % [n, c.ord, c]
  #       true
  #     elsif (0xF900..0xFAF0).cover?(c.ord) && c.unicode_normalize(:nfkc) != c
  #       puts 'CK 0x%04X U+%04X: %c' % [n, c.ord, c]
  #       true
  #     else
  #       false
  #     end
  #   end.map { |n| n.chr(Encoding::CP932) }.join.encode(Encoding::UTF_8)
  # end

  # CP932拡張文字
  # 別コード割り当てありと互換文字ありは除外(上記コード参照)
  CP932EXT = '①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳' \
             'ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡' \
             '㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼∮∑∟⊿ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ￤＇＂' \
             '纊褜鍈銈蓜俉炻昱棈鋹曻彅丨仡仼伀伃伹佖侒侊侚侔俍偀倢俿倞偆偰偂傔僴僘' \
             '兊兤冝冾凬刕劜劦勀勛匀匇匤卲厓厲叝﨎咜咊咩哿喆坙坥垬埈埇﨏增墲夋奓奛' \
             '奝奣妤妺孖寀甯寘寬尞岦岺峵崧嵓﨑嵂嵭嶸嶹巐弡弴彧德忞恝悅悊惞惕愠惲愑' \
             '愷愰憘戓抦揵摠撝擎敎昀昕昻昉昮昞昤晥晗晙晳暙暠暲暿曺朎杦枻桒柀栁桄棏' \
             '﨓楨﨔榘槢樰橫橆橳橾櫢櫤毖氿汜沆汯泚洄涇浯涖涬淏淸淲淼渹湜渧渼溿澈澵' \
             '濵瀅瀇瀨炅炫焏焄煜煆煇燁燾犱犾猤獷玽珉珖珣珒琇珵琦琪琩琮瑢璉璟甁畯皂' \
             '皜皞皛皦睆劯砡硎硤硺礰禔禛竑竧竫箞絈絜綷綠緖繒罇羡茁荢荿菇菶葈蒴蕓蕙' \
             '蕫﨟薰﨡蠇裵訒訷詹誧誾諟諶譓譿賰賴贒赶﨣軏﨤遧郞鄕鄧釚釗釞釭釮釤釥鈆' \
             '鈐鈊鈺鉀鈼鉎鉙鉑鈹鉧銧鉷鉸鋧鋗鋙鋐﨧鋕鋠鋓錥錡鋻﨨錞鋿錝錂鍰鍗鎤鏆鏞' \
             '鏸鐱鑅鑈閒﨩隝隯霳霻靃靍靏靑靕顗顥餧馞驎髙髜魵魲鮏鮱鮻鰀鵰鵫鸙黑'

  # 互換文字が存在するCP932拡張文字
  C932EXT_COMPITABLE = '塚晴朗凞猪益礼神祥福靖精羽蘒諸逸都隆飯飼館鶴'
  C932EXT_COMPITABLE_NORMAL = C932EXT_COMPITABLE.unicode_normalize(:nfkc)

  test 'normalize' do
    # same
    assert_equal SAMPLE_TEXT, Iso2022jp.normalize(SAMPLE_TEXT)
    assert_equal ZEN_TEXT, Iso2022jp.normalize(ZEN_TEXT)
    assert_equal ZEN2_TEXT, Iso2022jp.normalize(ZEN2_TEXT)
    assert_equal ZEN_TEXT_HAN, Iso2022jp.normalize(ZEN_TEXT_HAN)
    assert_equal HAN_TEXT_ZEN, Iso2022jp.normalize(HAN_TEXT_ZEN)
    assert_equal HAN2_TEXT_ZEN, Iso2022jp.normalize(HAN2_TEXT_ZEN)
    assert_equal ZEN_KATKANA, Iso2022jp.normalize(ZEN_KATKANA)
    assert_equal FULLWIDTH_TILDE, Iso2022jp.normalize(FULLWIDTH_TILDE)
    assert_equal FULLWIDTH_HYPHEN_MINUS, Iso2022jp.normalize(FULLWIDTH_HYPHEN_MINUS)
    assert_equal CP932EXT, Iso2022jp.normalize(CP932EXT)

    # diff
    assert_equal HAN_TEXT_ZEN, Iso2022jp.normalize(HAN_TEXT)
    assert_equal HAN2_TEXT_ZEN, Iso2022jp.normalize(HAN2_TEXT)
    assert_equal ZEN2_TEXT, Iso2022jp.normalize(ZEN2_TEXT_HAN)
    assert_equal ZEN_KATKANA, Iso2022jp.normalize(HAN_KATKANA)
    assert_equal FULLWIDTH_TILDE, Iso2022jp.normalize(WAVE_DASH)
    assert_equal FULLWIDTH_HYPHEN_MINUS, Iso2022jp.normalize(MINUS)
    assert_equal C932EXT_COMPITABLE_NORMAL, Iso2022jp.normalize(C932EXT_COMPITABLE)
  end

  test 'normalize no x0201' do
    # same
    assert_equal SAMPLE_TEXT, Iso2022jp.normalize(SAMPLE_TEXT, x0201: false)
    assert_equal ZEN_TEXT, Iso2022jp.normalize(ZEN_TEXT, x0201: false)
    assert_equal HAN_TEXT, Iso2022jp.normalize(HAN_TEXT, x0201: false)
    assert_equal ZEN2_TEXT, Iso2022jp.normalize(ZEN2_TEXT, x0201: false)
    assert_equal ZEN_TEXT_HAN, Iso2022jp.normalize(ZEN_TEXT_HAN, x0201: false)
    assert_equal HAN_TEXT_ZEN, Iso2022jp.normalize(HAN_TEXT_ZEN, x0201: false)
    assert_equal HAN2_TEXT_ZEN, Iso2022jp.normalize(HAN2_TEXT_ZEN, x0201: false)
    assert_equal HAN_KATKANA, Iso2022jp.normalize(HAN_KATKANA, x0201: false)
    assert_equal ZEN_KATKANA, Iso2022jp.normalize(ZEN_KATKANA, x0201: false)
    assert_equal FULLWIDTH_TILDE, Iso2022jp.normalize(FULLWIDTH_TILDE, x0201: false)
    assert_equal FULLWIDTH_HYPHEN_MINUS, Iso2022jp.normalize(FULLWIDTH_HYPHEN_MINUS, x0201: false)

    # diff
    assert_equal HAN2_TEXT_ZEN, Iso2022jp.normalize(HAN2_TEXT, x0201: false)
    assert_equal ZEN2_TEXT, Iso2022jp.normalize(ZEN2_TEXT_HAN, x0201: false)
    assert_equal FULLWIDTH_TILDE, Iso2022jp.normalize(WAVE_DASH, x0201: false)
    assert_equal FULLWIDTH_HYPHEN_MINUS, Iso2022jp.normalize(MINUS, x0201: false)
    assert_equal C932EXT_COMPITABLE_NORMAL, Iso2022jp.normalize(C932EXT_COMPITABLE, x0201: false)
  end

  test 'check_unconvertible_chars' do
    assert_equal [], Iso2022jp.check_unconvertible_chars(SAMPLE_TEXT)
    assert_equal %w[｟ ｠], Iso2022jp.check_unconvertible_chars(ZEN_TEXT)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT)
    assert_equal %w[￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT)
    assert_equal %w[⦅ ⦆], Iso2022jp.check_unconvertible_chars(ZEN_TEXT_HAN)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT_ZEN)
    assert_equal %w[￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT_HAN)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT_ZEN)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_KATKANA)
    assert_equal [], Iso2022jp.check_unconvertible_chars(ZEN_KATKANA)
    assert_equal [], Iso2022jp.check_unconvertible_chars(CP932EXT)
    assert_equal [], Iso2022jp.check_unconvertible_chars(C932EXT_COMPITABLE)
  end

  test 'check_unconvertible_chars no cp932' do
    assert_equal [], Iso2022jp.check_unconvertible_chars(SAMPLE_TEXT, cp932: false)
    assert_equal %w[＂ ＇ ｟ ｠], Iso2022jp.check_unconvertible_chars(ZEN_TEXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT, cp932: false)
    assert_equal %w[￤ ￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT, cp932: false)
    assert_equal %w[⦅ ⦆], Iso2022jp.check_unconvertible_chars(ZEN_TEXT_HAN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT_ZEN, cp932: false)
    assert_equal %w[￤ ￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT_HAN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT_ZEN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_KATKANA, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(ZEN_KATKANA, cp932: false)
    assert_equal CP932EXT.chars, Iso2022jp.check_unconvertible_chars(CP932EXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(C932EXT_COMPITABLE, cp932: false)
  end

  test 'double_conv_jis' do
    assert_equal SAMPLE_TEXT, Iso2022jp.double_conv_jis(SAMPLE_TEXT)
  end

  test 'double_conv_jis no x0201' do
    assert_equal SAMPLE_TEXT, Iso2022jp.double_conv_jis(SAMPLE_TEXT, x0201: false)
  end

  test 'double_conv_jis no cp932' do
    assert_equal SAMPLE_TEXT, Iso2022jp.double_conv_jis(SAMPLE_TEXT, cp932: false)
  end

  test 'double_conv_jis no cp932, no x0201' do
    assert_equal SAMPLE_TEXT, Iso2022jp.double_conv_jis(SAMPLE_TEXT, cp932: false, x0201: false)
  end
end
