require 'test_helper'
require 'japanese_wrap'

class JapaneseWrapTest < ActiveSupport::TestCase
  SAMPLE_TEXT = <<~TEXT.freeze
    　メロスは激怒した。必ず、かの邪智暴虐の王を除かなければならぬと決意した。メロスには政治がわからぬ。メロスは、村の牧人である。笛を吹き、羊と遊んで暮して来た。けれども邪悪に対しては、人一倍に敏感であった。きょう未明メロスは村を出発し、野を越え山越え、十里はなれた此のシラクスの市にやって来た。メロスには父も、母も無い。女房も無い。十六の、内気な妹と二人暮しだ。この妹は、村の或る律気な一牧人を、近々、花婿として迎える事になっていた。結婚式も間近かなのである。メロスは、それゆえ、花嫁の衣裳やら祝宴の御馳走やらを買いに、はるばる市にやって来たのだ。先ず、その品々を買い集め、それから都の大路をぶらぶら歩いた。メロスには竹馬の友があった。セリヌンティウスである。今は此のシラクスの市で、石工をしている。その友を、これから訪ねてみるつもりなのだ。久しく逢わなかったのだから、訪ねて行くのが楽しみである。歩いているうちにメロスは、まちの様子を怪しく思った。ひっそりしている。もう既に日も落ちて、まちの暗いのは当りまえだが、けれども、なんだか、夜のせいばかりでは無く、市全体が、やけに寂しい。のんきなメロスも、だんだん不安になって来た。路で逢った若い衆をつかまえて、何かあったのか、二年まえに此の市に来たときは、夜でも皆が歌をうたって、まちは賑やかであった筈だが、と質問した。若い衆は、首を振って答えなかった。しばらく歩いて老爺に逢い、こんどはもっと、語勢を強くして質問した。老爺は答えなかった。メロスは両手で老爺のからだをゆすぶって質問を重ねた。老爺は、あたりをはばかる低声で、わずか答えた。
    「王様は、人を殺します。」
    「なぜ殺すのだ。」
    「悪心を抱いている、というのですが、誰もそんな、悪心を持っては居りませぬ。」
    「たくさんの人を殺したのか。」
    「はい、はじめは王様の妹婿さまを。それから、御自身のお世嗣を。それから、妹さまを。それから、妹さまの御子さまを。それから、皇后さまを。それから、賢臣のアレキス様を。」
    「おどろいた。国王は乱心か。」
    「いいえ、乱心ではございませぬ。人を、信ずる事が出来ぬ、というのです。このごろは、臣下の心をも、お疑いになり、少しく派手な暮しをしている者には、人質ひとりずつ差し出すことを命じて居ります。御命令を拒めば十字架にかけられて、殺されます。きょうは、六人殺されました。」
    　聞いて、メロスは激怒した。「呆れた王だ。生かして置けぬ。」
  TEXT

  test 'force Engrish' do
    text = 'All your code are belong to us.'
    assert_equal "All your c\node are be\nlong to us\n.", JapaneseWrap.text_wrap(text, col: 10, rule: :force)
    assert_equal "All your code are be\nlong to us.", JapaneseWrap.text_wrap(text, col: 20, rule: :force)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 40, rule: :force)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 80, rule: :force)
  end

  test 'word wrap Engrish' do
    text = 'All your code are belong to us.'
    assert_equal "All your\ncode are\nbelong to\nus.", JapaneseWrap.text_wrap(text, col: 10, rule: :word_wrap)
    assert_equal "All your code are\nbelong to us.", JapaneseWrap.text_wrap(text, col: 20, rule: :word_wrap)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 40, rule: :word_wrap)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 80, rule: :word_wrap)
  end

  test 'jisx4051 Engrish' do
    text = 'All your code are belong to us.'
    assert_equal "All your\ncode are\nbelong to\nus.", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "All your code are\nbelong to us.", JapaneseWrap.text_wrap(text, col: 20, rule: :jisx4051)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 40, rule: :jisx4051)
    assert_equal 'All your code are belong to us.', JapaneseWrap.text_wrap(text, col: 80, rule: :jisx4051)
  end

  test 'search breakable word wrap Engrish' do
    text = 'All your code are belong to us.'
    assert_equal 9, JapaneseWrap.search_breakable_word_wrap(text, 10)
    assert_equal 9, JapaneseWrap.search_breakable_word_wrap(text, 11)
    assert_equal 9, JapaneseWrap.search_breakable_word_wrap(text, 12)
    assert_equal 14, JapaneseWrap.search_breakable_word_wrap(text, 13)
    assert_equal 14, JapaneseWrap.search_breakable_word_wrap(text, 14)
    assert_equal 14, JapaneseWrap.search_breakable_word_wrap(text, 15)
    assert_equal 14, JapaneseWrap.search_breakable_word_wrap(text, 16)
    assert_equal 18, JapaneseWrap.search_breakable_word_wrap(text, 17)

    assert_equal 28, JapaneseWrap.search_breakable_word_wrap(text, 30)
    assert_equal 31, JapaneseWrap.search_breakable_word_wrap(text, 31)
    assert_equal 32, JapaneseWrap.search_breakable_word_wrap(text, 32)

    assert_equal 80, JapaneseWrap.search_breakable_word_wrap(text, 80)
  end

  test 'force 日本語' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal "君達のソー\nスコードは\n、全てRuby\n on Rails\nがいただい\nた。",
      JapaneseWrap.text_wrap(text, col: 10, rule: :force)
    assert_equal "君達のソースコードは\n、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 20, rule: :force)
    assert_equal "君達のソースコードは、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 40, rule: :force)
    assert_equal '君達のソースコードは、全てRuby on Railsがいただいた。',
      JapaneseWrap.text_wrap(text, col: 80, rule: :force)
  end

  test 'word wrap 日本語' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal "君達のソー\nスコードは\n、全てRuby\non Railsが\nいただいた\n。",
      JapaneseWrap.text_wrap(text, col: 10, rule: :word_wrap)
    assert_equal "君達のソースコードは\n、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 20, rule: :word_wrap)
    assert_equal "君達のソースコードは、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 40, rule: :word_wrap)
    assert_equal '君達のソースコードは、全てRuby on Railsがいただいた。',
      JapaneseWrap.text_wrap(text, col: 80, rule: :word_wrap)
  end

  test 'jisx4051 日本語' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal "君達のソー\nスコード\nは、全て\nRuby on\nRailsがい\nただいた。",
      JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "君達のソースコード\nは、全てRuby on\nRailsがいただいた。",
      JapaneseWrap.text_wrap(text, col: 20, rule: :jisx4051)
    assert_equal "君達のソースコードは、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 40, rule: :jisx4051)
    assert_equal '君達のソースコードは、全てRuby on Railsがいただいた。',
      JapaneseWrap.text_wrap(text, col: 80, rule: :jisx4051)
  end

  test 'jisx4051 hanging 日本語' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal "君達のソー\nスコードは、\n全てRuby\non Railsが\nいただいた。",
      JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051, hanging: true)
    assert_equal "君達のソースコードは、\n全てRuby on Railsが\nいただいた。",
      JapaneseWrap.text_wrap(text, col: 20, rule: :jisx4051, hanging: true)
    assert_equal "君達のソースコードは、全てRuby on Rails\nがいただいた。",
      JapaneseWrap.text_wrap(text, col: 40, rule: :jisx4051, hanging: true)
    assert_equal '君達のソースコードは、全てRuby on Railsがいただいた。',
      JapaneseWrap.text_wrap(text, col: 80, rule: :jisx4051, hanging: true)
  end

  test 'search breakable jisx4051 Engrish' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal 6, JapaneseWrap.search_breakable_jisx4051(text, 6)
    assert_equal 6, JapaneseWrap.search_breakable_jisx4051(text, 7)
    assert_equal 8, JapaneseWrap.search_breakable_jisx4051(text, 8) # 行頭禁則文字「ー」
    assert_equal 9, JapaneseWrap.search_breakable_jisx4051(text, 9)
    assert_equal 9, JapaneseWrap.search_breakable_jisx4051(text, 10) # 行頭禁則文字「、」
    assert_equal 11, JapaneseWrap.search_breakable_jisx4051(text, 11)
    assert_equal 12, JapaneseWrap.search_breakable_jisx4051(text, 12)
    assert_equal 13, JapaneseWrap.search_breakable_jisx4051(text, 13) # 英単語
    assert_equal 13, JapaneseWrap.search_breakable_jisx4051(text, 14) # 英単語
    assert_equal 13, JapaneseWrap.search_breakable_jisx4051(text, 15) # 英単語
    assert_equal 13, JapaneseWrap.search_breakable_jisx4051(text, 16) # 英単語
    assert_equal 18, JapaneseWrap.search_breakable_jisx4051(text, 17) # スペース
    assert_equal 18, JapaneseWrap.search_breakable_jisx4051(text, 18) # 英単語
    assert_equal 18, JapaneseWrap.search_breakable_jisx4051(text, 19) # 英単語
    assert_equal 21, JapaneseWrap.search_breakable_jisx4051(text, 20) # スペース
    assert_equal 21, JapaneseWrap.search_breakable_jisx4051(text, 21) # 英単語
    assert_equal 21, JapaneseWrap.search_breakable_jisx4051(text, 25) # 英単語
    assert_equal 26, JapaneseWrap.search_breakable_jisx4051(text, 26)

    assert_equal 31, JapaneseWrap.search_breakable_jisx4051(text, 31)
    assert_equal 31, JapaneseWrap.search_breakable_jisx4051(text, 32) # 行頭禁則文字「。」
    assert_equal 33, JapaneseWrap.search_breakable_jisx4051(text, 33)
    assert_equal 34, JapaneseWrap.search_breakable_jisx4051(text, 34)

    assert_equal 80, JapaneseWrap.search_breakable_jisx4051(text, 80)
  end

  test '1倍幅サロゲートペア' do
    # UTF-8で処理するため、U+10000以上も一つの文字として処理される。
    text = '𠮷田の𠮷は土に口です。'
    assert_equal "𠮷田の\n𠮷は土\nに口で\nす。", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "𠮷田の\n𠮷は土\nに口で\nす。", JapaneseWrap.text_wrap(text, col: 7, rule: :jisx4051)
    assert_equal "𠮷田の𠮷\nは土に口\nです。", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
  end

  test 'ギリシャ文字とキリル文字' do
    list = ['α', 'д']
    # デフォルト幅 2
    list.each do |char|
      text = "前文#{char}後文"
      assert_equal "前文\n#{char}後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
      assert_equal "前文\n#{char}後\n文", JapaneseWrap.text_wrap(text, col: 5, rule: :jisx4051)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 7, rule: :jisx4051)
    end

    # 幅1
    list.each do |char|
      text = "前文#{char}後文"
      assert_equal "前文\n#{char}後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051, ambiguous: 1)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 5, rule: :jisx4051, ambiguous: 1)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051, ambiguous: 1)
      assert_equal "前文#{char}後\n文", JapaneseWrap.text_wrap(text, col: 7, rule: :jisx4051, ambiguous: 1)
    end

    # 幅2
    list.each do |char|
      text = "前文#{char}後文"
      assert_equal "前文\n#{char}後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051, ambiguous: 2)
      assert_equal "前文\n#{char}後\n文", JapaneseWrap.text_wrap(text, col: 5, rule: :jisx4051, ambiguous: 2)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051, ambiguous: 2)
      assert_equal "前文#{char}\n後文", JapaneseWrap.text_wrap(text, col: 7, rule: :jisx4051, ambiguous: 2)
    end
  end

  # 行頭禁止
  # 行末禁止

  test '複雑な組み合わせ: 行末禁止の後の空白' do
    text = '前文  」後文'
    assert_equal "前\n文\n」\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前\n文\n」後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前\n文  」\n後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文  」\n後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文  」後\n文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 行末禁止のあとの空白' do
    text = '前文「  後文'
    assert_equal "前\n文\n「\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前文\n「\n後文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前文「\n後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文「\n後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文「  後\n文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 囲まれた空白' do
    text = '前文「    」後文'
    assert_equal "前\n文\n「\n」\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前文\n「\n」後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前文\n「\n」後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文\n「    」\n後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文\n「    」後\n文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "前文「    」\n後文", JapaneseWrap.text_wrap(text, col: 12, rule: :jisx4051)
    assert_equal "前文「    」後\n文", JapaneseWrap.text_wrap(text, col: 14, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 囲まれた単語' do
    text = '前文「word」後文'
    assert_equal "前\n文\n「\nwo\nr\nd\n」\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前文\n「\nwor\nd」\n後文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前文\n「word\n」後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文\n「word」\n後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文\n「word」後\n文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "前文「word」\n後文", JapaneseWrap.text_wrap(text, col: 12, rule: :jisx4051)
    assert_equal "前文「word」後\n文", JapaneseWrap.text_wrap(text, col: 14, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 始まり括弧の連続' do
    text = '前文「「「「後文'
    assert_equal "前\n文\n「\n「\n「\n「\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前文\n「「\n「「\n後文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前文\n「「「\n「後文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文\n「「「「\n後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文\n「「「「後\n文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "前文\n「「「「後文", JapaneseWrap.text_wrap(text, col: 12, rule: :jisx4051)
    assert_equal "前文「「「「後\n文", JapaneseWrap.text_wrap(text, col: 14, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 終わり括弧の連続' do
    text = '前文」」」」後文'
    assert_equal "前\n文\n」\n」\n」\n」\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前\n文」\n」」\n」後\n文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前\n文」」\n」」後\n文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前\n文」」」\n」後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前\n文」」」」\n後文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "前文」」」」\n後文", JapaneseWrap.text_wrap(text, col: 12, rule: :jisx4051)
    assert_equal "前文」」」」後\n文", JapaneseWrap.text_wrap(text, col: 14, rule: :jisx4051)
  end

  test '複雑な組み合わせ: 括弧の連続' do
    text = '前文「」「」後文'
    assert_equal "前\n文\n「\n」\n「\n」\n後\n文", JapaneseWrap.text_wrap(text, col: 2, rule: :jisx4051)
    assert_equal "前文\n「」\n「」\n後文", JapaneseWrap.text_wrap(text, col: 4, rule: :jisx4051)
    assert_equal "前文\n「」\n「」後\n文", JapaneseWrap.text_wrap(text, col: 6, rule: :jisx4051)
    assert_equal "前文「」\n「」後文", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
    assert_equal "前文「」\n「」後文", JapaneseWrap.text_wrap(text, col: 10, rule: :jisx4051)
    assert_equal "前文「」「」\n後文", JapaneseWrap.text_wrap(text, col: 12, rule: :jisx4051)
    assert_equal "前文「」「」後\n文", JapaneseWrap.text_wrap(text, col: 14, rule: :jisx4051)
  end

  test '強制切断' do
    text = "abcdefghijklmnopqrstvwxyz0123456789"
    assert_equal "abcdefgh\nijklmnop\nqrstvwxy\nz0123456\n789", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)

    text = "「「「「「「「「「「「「「「「「「「"
    assert_equal "「「「「\n「「「「\n「「「「\n「「「「\n「「", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)

    text = "」」」」」」」」」」」」」」」」」」」"
    assert_equal "」」」」\n」」」」\n」」」」\n」」」」\n」」」", JapaneseWrap.text_wrap(text, col: 8, rule: :jisx4051)
  end

  test 'not wrap 日本語' do
    text = '君達のソースコードは、全てRuby on Railsがいただいた。'
    assert_equal text, JapaneseWrap.text_wrap(text, col: 0)
    assert_equal text, JapaneseWrap.text_wrap(text, col: -1)
    assert_equal text, JapaneseWrap.text_wrap(text, col: 80, rule: :none)
  end
end
