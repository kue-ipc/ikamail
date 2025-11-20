module LdapAttribute
  extend ActiveSupport::Concern

  def ldap_attribute(attr_name, lang: I18n.default_locale)
    case (value = self[attr_name])
    in nil then nil
    in String then value
    in Array then find_lang_specific_attribute(value, lang:)
    in Hash then value.first.last
    else value.to_s
    end
  end

  # valuse is [String | {String => String}]
  def find_lang_specific_attribute(values, lang: I18n.default_locale)
    if lang.nil?
      return valuse.find { |v| v.is_a?(String) } || valuse.first.value
    end

    lang_key = "lang-#{lang}"
    value = nil
    values.each do |v|
      if v.is_a?(String)
        value ||= v
      elsif v.key?(lang_key)
        return v[lang_key]
      end
    end
    value
  end
end
