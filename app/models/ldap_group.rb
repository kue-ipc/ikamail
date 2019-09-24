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

end
