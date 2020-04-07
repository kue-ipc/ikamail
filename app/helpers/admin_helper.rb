# frozen_string_literal: true

module AdminHelper
  def translations_each(locale, key, value, &block)
    case value
    when String
      yield key, value, Translation.find_by(locale: locale, key: key).present?
    when Numeric
    when true, false
    when Array
    when Proc
    when Hash
      value.each do |child_key, child_value|
        full_key =
          if key.present?
            key + '.' + child_key.to_s
          else
            child_key.to_s
          end
        translations_each(locale, full_key, child_value, &block)
      end
    else
      raise "Unknown data type: #{value.class}"
    end
  end
end
