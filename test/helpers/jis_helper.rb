require "nkf"

module JisHelper
  def u8tojis(str)
    NKF.nkf("-W -j", str).force_encoding(Encoding::US_ASCII)
  end

  def u8tomjis(str)
    NKF.nkf("-W -j -M", str).force_encoding(Encoding::US_ASCII)
  end

  def jistou8(str)
    NKF.nkf("-J -w", str)
  end

  def mjistou8(str)
    NKF.nkf("-J -w -m", str)
  end
end
