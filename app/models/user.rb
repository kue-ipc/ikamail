# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :registerable, :recoverable, :rememberable, :validatable
  # and :omniauthable
  devise :ldap_authenticatable, :lockable, :timeoutable, :trackable

  def ldap_before_save
    entry = Devise::LDAP::Adapter.get_ldap_entry(self.username)
    self.email = entry['mail'].first
    self.fullname = entry["display_name;lang-#{I18n.default_locale}"]&.first ||
                    entry['display_name']&.first
  end
end
