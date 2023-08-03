# rubocop: disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: Settings.ldap.group.dn,
    prefix: Settings.ldap.group.ou,
    classes: Settings.ldap.group.classes

  has_many :primary_users, class_name: 'LdapUser',
    primary_key: 'gidNumber',
    foreign_key: 'gidNumber'

  has_many :users, class_name: 'LdapUser',
    primary_key: 'uid',
    wrap: 'memberUid'

  def name
    self[dn_attribute]
  end

  def display_name
    case self['description']
    when nil then name
    when String then self['description']
    when Array
      lang = "lang-#{I18n.default_locale}"
      lang_desc = name
      self['description'].each do |desc|
        if desc.is_a?(String)
          lang_desc = desc
        elsif desc[lang].is_a?(String)
          lang_desc = desc[lang]
          break
        end
      end
      lang_desc
    when Hash then self['description'].values.first
    else self['description'].to_s
    end
  end

  def self.find_dn(name)
    find(:first, filter: {dn_attribute => name})
  end
end
# rubocop: enable Rails/HasManyOrHasOneDependent, Rails/InverseOf
