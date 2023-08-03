require 'test_helper'
require 'iso2022jp'

class Iso2022jpTest < ActiveSupport::TestCase
  ASCII_TEXT = (0x20..0x7F).map { |n| n.chr(Encoding::UTF_8) }.join.freeze
  ZEN_TEXT = (0xFF01..0xFF60).map { |n| n.chr(Encoding::UTF_8) }.join.freeze
  HAN_TEXT = (0xFF61..0xFF9F).map { |n| n.chr(Encoding::UTF_8) }.join.freeze
  ZEN2_TEXT = (0xFFE0..0xFFE6).map { |n| n.chr(Encoding::UTF_8) }.join.freeze
  HAN2_TEXT = (0xFFE8..0xFFEE).map { |n| n.chr(Encoding::UTF_8) }.join.freeze

  ZEN_TEXT_HAN = ZEN_TEXT.unicode_normalize(:nfkc).freeze
  HAN_TEXT_ZEN = HAN_TEXT.unicode_normalize(:nfkc).tr("\u3099\u309A", "\u309B\u309C").freeze
  ZEN2_TEXT_HAN = ZEN2_TEXT.unicode_normalize(:nfkc).freeze
  HAN2_TEXT_ZEN = HAN2_TEXT.unicode_normalize(:nfkc).freeze

  HAN_KATKANA = -'ｱｶｻﾀﾅﾊﾏﾔﾗﾜｶﾞｻﾞﾀﾞﾊﾞﾊﾟｳﾞﾝ'
  ZEN_KATKANA = -'アカサタナハマヤラワガザダバパヴン'

  WAVE_DASH = -"\u301C"
  FULLWIDTH_TILDE = -"\uFF5E"
  MINUS = -"\u2212"
  FULLWIDTH_HYPHEN_MINUS = -"\uFF0D"

  SAMPLE_TEXT = -'!aAあア亜！ａＡ'

  def cp932ext
    [
      (0x8740..0x875D),
      (0x875F..0x8775),
      [0x877E],
      (0x8780..0x878F),
      (0x8790..0x879C),
      (0xFA40..0xFA7E),
      (0xFA80..0xFAFC),
      (0xFB40..0xFB7E),
      (0xFB80..0xFBFC),
      (0xFC40..0xFC4B),
    ].flat_map(&:to_a)
      .select { |n| n.chr(Encoding::CP932).encode(Encoding::UTF_8).encode(Encoding::CP932).ord == n }
      .map { |n| n.chr(Encoding::CP932) }.join.encode(Encoding::UTF_8)
  end

  # CP932拡張文字
  # 別コード割り当てありは除外(上記コード参照)
  CP932EXT = -
    '①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳' \
    'ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡' \
    '㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼∮∑∟⊿ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ￤＇＂' \
    '纊褜鍈銈蓜俉炻昱棈鋹曻彅丨仡仼伀伃伹佖侒侊侚侔俍偀倢俿倞偆偰偂傔僴僘' \
    '兊兤冝冾凬刕劜劦勀勛匀匇匤卲厓厲叝﨎咜咊咩哿喆坙坥垬埈埇﨏塚增墲夋奓' \
    '奛奝奣妤妺孖寀甯寘寬尞岦岺峵崧嵓﨑嵂嵭嶸嶹巐弡弴彧德忞恝悅悊惞惕愠惲' \
    '愑愷愰憘戓抦揵摠撝擎敎昀昕昻昉昮昞昤晥晗晙晴晳暙暠暲暿曺朎朗杦枻桒柀' \
    '栁桄棏﨓楨﨔榘槢樰橫橆橳橾櫢櫤毖氿汜沆汯泚洄涇浯涖涬淏淸淲淼渹湜渧渼' \
    '溿澈澵濵瀅瀇瀨炅炫焏焄煜煆煇凞燁燾犱犾猤猪獷玽珉珖珣珒琇珵琦琪琩琮瑢' \
    '璉璟甁畯皂皜皞皛皦益睆劯砡硎硤硺礰礼神祥禔福禛竑竧靖竫箞精絈絜綷綠緖' \
    '繒罇羡羽茁荢荿菇菶葈蒴蕓蕙蕫﨟薰蘒﨡蠇裵訒訷詹誧誾諟諸諶譓譿賰賴贒赶' \
    '﨣軏﨤逸遧郞都鄕鄧釚釗釞釭釮釤釥鈆鈐鈊鈺鉀鈼鉎鉙鉑鈹鉧銧鉷鉸鋧鋗鋙鋐' \
    '﨧鋕鋠鋓錥錡鋻﨨錞鋿錝錂鍰鍗鎤鏆鏞鏸鐱鑅鑈閒隆﨩隝隯霳霻靃靍靏靑靕顗' \
    '顥飯飼餧館馞驎髙髜魵魲鮏鮱鮻鰀鵰鵫鶴鸙黑'

  # 第一水準
  JIS1L = -'亜唖娃'
  # 第二水準
  JIS2L = -'弌丐丕'
  # 第三水準
  JIS3L = -'俱𠀋㐂'
  # 第四水準
  JIS4L = -'𠂉丂丏'
  # 記号
  NO_JIS = -'♡☕👨‍👩‍👧‍👦🗿'

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
    assert_equal CP932EXT, Iso2022jp.normalize(CP932EXT, x0201: false)

    # diff
    assert_equal HAN2_TEXT_ZEN, Iso2022jp.normalize(HAN2_TEXT, x0201: false)
    assert_equal ZEN2_TEXT, Iso2022jp.normalize(ZEN2_TEXT_HAN, x0201: false)
    assert_equal FULLWIDTH_TILDE, Iso2022jp.normalize(WAVE_DASH, x0201: false)
    assert_equal FULLWIDTH_HYPHEN_MINUS, Iso2022jp.normalize(MINUS, x0201: false)
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
    assert_equal [], Iso2022jp.check_unconvertible_chars(JIS1L)
    assert_equal [], Iso2022jp.check_unconvertible_chars(JIS2L)
    assert_equal JIS3L.chars, Iso2022jp.check_unconvertible_chars(JIS3L)
    assert_equal JIS4L.chars, Iso2022jp.check_unconvertible_chars(JIS4L)
    assert_equal NO_JIS.chars, Iso2022jp.check_unconvertible_chars(NO_JIS)
  end

  test 'check_unconvertible_chars no cp932' do
    assert_equal [], Iso2022jp.check_unconvertible_chars(SAMPLE_TEXT, cp932: false)
    # diff cp932
    assert_equal %w[＂ ＇ ｟ ｠], Iso2022jp.check_unconvertible_chars(ZEN_TEXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT, cp932: false)
    # diff cp932
    assert_equal %w[￤ ￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT, cp932: false)
    assert_equal %w[⦅ ⦆], Iso2022jp.check_unconvertible_chars(ZEN_TEXT_HAN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_TEXT_ZEN, cp932: false)
    # diff cp932
    assert_equal %w[￤ ￦], Iso2022jp.check_unconvertible_chars(ZEN2_TEXT_HAN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN2_TEXT_ZEN, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(HAN_KATKANA, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(ZEN_KATKANA, cp932: false)
    # diff cp932
    assert_equal CP932EXT.chars, Iso2022jp.check_unconvertible_chars(CP932EXT, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(JIS1L, cp932: false)
    assert_equal [], Iso2022jp.check_unconvertible_chars(JIS2L, cp932: false)
    assert_equal JIS3L.chars, Iso2022jp.check_unconvertible_chars(JIS3L, cp932: false)
    assert_equal JIS4L.chars, Iso2022jp.check_unconvertible_chars(JIS4L, cp932: false)
    assert_equal NO_JIS.chars, Iso2022jp.check_unconvertible_chars(NO_JIS, cp932: false)
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
