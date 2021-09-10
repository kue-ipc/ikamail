class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: configurations['ldap']['user']['dn'],
    prefix: configurations['ldap']['user']['base'],
    classes: configurations['ldap']['user']['classes']

  belongs_to :primary_group, class_name: 'LdapGroup',
                             primary_key: 'gidNumber',
                             foreign_key: 'gidNumber'

  belongs_to :groups, class_name: 'LdapGroup',
                      primary_key: 'uid',
                      many: 'memberUid'

  def name
    self[dn_attribute]
  end

  def display_name
    case self['displayName']
    when nil
      name
    when String
      self['displayName']
    when Array
      lang = "lang-#{I18n.default_locale}"
      lang_desc = name
      self['displayName'].each do |desc|
        if desc.is_a?(String)
          lang_desc = desc
        elsif desc[lang].is_a?(String)
          lang_desc = desc[lang]
          break
        end
      end
      lang_desc
    when Hash
      self['description'].values.first
    else
      self['displayName']
    end
  end

  def self.find_dn(name)
    find(:first, filter: {dn_attribute => name})
  end
end
