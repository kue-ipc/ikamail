# libary for ISO-2022-JP (JIS code)

require 'nkf'

module Iso2022jp
  NO_JIS_CHARS = %w[
    丨 仡 伀 伃 伹 佖 侊 侒 侔 侚 俉 俍 俿 倞 倢 偀 偂 偆 偰 傔 僘 兊 兤 冝 冾
    刕 劜 劦 劯 勀 勛 匀 卲 厓 厲 叝 咜 咩 哿 喆 坥 垬 埇 埈 墲 夋 奓 奛 奝 奣
    妤 妺 孖 寀 寘 尞 岦 岺 崧 嵂 嵭 嶸 嶹 巐 弡 弴 彅 彧 忞 恝 悊 惕 惞 惲 愑
    愰 愷 憘 戓 抦 揵 摠 撝 擎 昀 昉 昕 昞 昤 昮 昱 晗 晙 晳 暙 暠 暲 暿 曺 曻
    朎 杦 枻 柀 桄 桒 棈 棏 楨 榘 槢 樰 橆 橳 橾 櫤 毖 氿 汜 汯 沆 泚 洄 浯 涇
    涖 涬 淏 淼 渧 渹 渼 湜 溿 澈 澵 濵 瀅 瀇 炅 炫 焄 焏 煆 煇 煜 燁 燾 犱 犾
    猤 獷 玽 珉 珒 珖 珣 珵 琇 琦 琩 琪 琮 瑢 璉 璟 甯 畯 皛 皜 皦 睆 砡 硎 硤
    硺 禔 禛 竑 竫 箞 絈 絜 綷 繒 纊 罇 羡 茁 荿 菇 菶 葈 蒴 蓜 蕓 蕙 蕫 裵 褜
    訒 訷 詹 誧 誾 諟 諶 譓 賰 贒 軏 遧 鄧 釗 釚 釞 釤 釥 釭 釮 鈆 鈊 鈐 鈹 鈺
    鈼 鉀 鉎 鉑 鉙 鉧 鉷 鉸 銈 銧 鋐 鋓 鋕 鋗 鋙 鋠 鋧 鋹 鋻 鋿 錂 錝 錞 錡 錥
    鍈 鍗 鍰 鎤 鏆 鏞 鏸 鐱 鑅 鑈 隝 隯 霳 靃 靏 靕 顗 顥 餧 驎 髜 魵 鮏 鮱 鮻
    鰀 鵫 鵰 鸙
    ￤
  ].freeze

  module_function # rubocop:disable Style/AccessModifierDeclarations

  def check_unconvertible_chars(str, strict: true)
    no_amp_str = str.gsub('&', '&amp;')
    conv_str = double_conv_jis(no_amp_str, fallback: :xml, cp932ext: !strict)
    list = conv_str.scan(/&\#x(\h{1,6});/).map { |m| m[0].to_i(16).chr }
    list.concat(conv_str.scan(Regexp.union(NO_JIS_CHARS))) if strict
    list
  end

  def double_conv_jis(str, fallback: :skip, cp932ext: false)
    fallback = fallback.intern
    raise ArgumentError, 'invalid fallback' unless %i[skip html xml perl java subchar].include?(fallback)

    nkf_opts = ['-W', '-j']
    nkf_opts << "--fb-#{fallback}" if fallback != :skip
    nkf_opts << '--no-cp932ext' unless cp932ext

    NKF.nkf('-J -w', NKF.nkf(nkf_opts.join(' '), str))
  end
end
