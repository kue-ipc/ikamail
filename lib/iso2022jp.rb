# frozen_string_literal: true

# ISO-2022-JP いわやる JISコード について

require 'nkf'

module Iso2022jp
  module_function

  def check_unconvertible_chars(str)
    no_amp_str = str.gsub('&', '&amp;')
    conv_str = double_conv_jis(no_amp_str, fallback: 'xml')
    conv_str.scan(/&\#x(\h{1,6});/i).map { |m| m.first.to_i(16).chr }
  end

  def double_conv_jis(str, fallback: 'skip')
    raise ArgumentError, 'invalid fallback' unless %w[skip html xml perl java subchar].include?(fallback)

    fb = "--fb-#{fallback}"
    NKF.nkf('-J -w', NKF.nkf("-W -j #{fb}", str))
  end
end
