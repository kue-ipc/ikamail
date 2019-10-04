class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: configurations['ldap']['group_dn'],
               prefix: configurations['ldap']['group_base'],
               classes: configurations['ldap']['group_classes']

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
    self["description;lang-#{I18n.default_locale}"] || self['description']
  end

  def self.find_by_name(name)
    find(:first, filter: {dn_attribute => name})
  end
end
