# rubocop: disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
class LdapGroup < ActiveLdap::Base
  include LdapAttribute

  ldap_mapping dn_attribute: Settings.ldap.group.dn,
    prefix: Settings.ldap.group.ou,
    classes: Settings.ldap.group.classes

  has_many :primary_users, class_name: "LdapUser",
    primary_key: "gidNumber",
    foreign_key: "gidNumber"

  has_many :users, class_name: "LdapUser",
    primary_key: "uid",
    wrap: "memberUid"

  def name
    self[dn_attribute]
  end

  def display_name
    lang = (I18n.locale || I18n.default_locale)&.intern
    ldap_attribute("description", lang:) ||
    name
  end

  def self.find_dn(name)
    find(:first, filter: {dn_attribute => name})
  end
end
# rubocop: enable Rails/HasManyOrHasOneDependent, Rails/InverseOf
