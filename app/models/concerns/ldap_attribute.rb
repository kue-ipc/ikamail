module LdapAttribute
  extend ActiveSupport::Concern

  def ldap_attribute(attr_name, lang: I18n.default_locale)
    find_specific_lang_attribute(self[attr_name], lang:)
  end

  # valus is nil | Stringc | {String => ...} | [String | {String => ...}]
  private def find_specific_lang_attribute(value, lang: nil)
    return nil if value.blank?
    return value if value.is_a?(String) && lang.nil?

    value= [value] if value.is_a?(Hash)
    return value.to_s unless value.is_a?(Array)

    preferred_value = nil
    if lang
      lang_key = "lang-#{lang}"
      lang_value = value.select { |v| v.is_a?(Hash) && v.key?(lang_key) }.pluck(lang_key)
      preferred_value = find_specific_lang_attribute(lang_value)
    end

    preferred_value ||
    value.find { |v| v.is_a?(String) } ||
    value.find { |v| v.is_a?(Hash) && find_specific_lang_attribute(v.values) }
  end
end
