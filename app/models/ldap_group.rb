class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: configurations['ldap']['group']['dn'],
               prefix: configurations['ldap']['group']['base'],
               classes: configurations['ldap']['group']['classes']

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
    when nil
      name
    when String
      self['description']
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
    when Hash
      self['description'].values.first
    else
      self['description']
    end
  end

  def self.find_by_name(name)
    find(:first, filter: {dn_attribute => name})
  end
end
