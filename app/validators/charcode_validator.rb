require "iso2022jp"

class CharcodeValidator < ActiveModel::EachValidator
  include Iso2022jp

  def validate_each(record, attribute, value)
    unconvertible_chars = check_unconvertible_chars(value, cp932: false)
    record.errors.add(attribute, :uncovertible_char, chars: unconvertible_chars.join) unless unconvertible_chars.empty?
  end
end
