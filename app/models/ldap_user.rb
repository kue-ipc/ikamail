class LdapUser < ActiveLdap::Base
  ldap_mapping dn_attribute: configurations['ldap']['user_dn'],
               prefix: configurations['ldap']['user_base'],
               classes: configurations['ldap']['user_classes']

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
    self['displayName;lang-ja'] || self['displayName']
  end

  def self.find_by_name(name)
    find(:first, filter: {dn_attribute => name})
  end

end
