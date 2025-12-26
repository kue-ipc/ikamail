# rubocop: disable Rails/InverseOf
class LdapUser < ActiveLdap::Base
  include LdapAttribute

  ldap_mapping dn_attribute: Settings.ldap.user.dn,
    prefix: Settings.ldap.user.ou,
    classes: Settings.ldap.user.classes

  belongs_to :primary_group, class_name: "LdapGroup",
    primary_key: "gidNumber",
    foreign_key: "gidNumber"

  belongs_to :groups, class_name: "LdapGroup",
    primary_key: "uid",
    many: "memberUid"

  def name
    self[dn_attribute]
  end

  def display_name
    lang = (I18n.locale || I18n.default_locale)&.intern
    (lang == :ja && ldap_attribute("jaDisplayName", lang: nil)) ||
      ldap_attribute("displayName", lang:) ||
      name
  end

  def self.find_dn(name)
    find(:first, filter: {dn_attribute => name})
  end
end
# rubocop: enable Rails/InverseOf
