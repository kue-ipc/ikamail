class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: configurations['ldap']['group_dn'],
               prefix: configurations['ldap']['group_base'],
               classes: configurations['ldap']['group_classes']
end
