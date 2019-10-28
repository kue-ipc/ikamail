# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :registerable, :recoverable, :validatable
  # and :omniauthable, :lockable, :timeoutable, :trackable
  devise :ldap_authenticatable, :rememberable

  validates :username, presence: true, uniqueness: true

  has_many :templates, dependent: :restrict_with_exception
  has_many :bulk_mails, dependent: :restrict_with_exception

  def ldap_before_save
    entry = Devise::LDAP::Adapter.get_ldap_entry(username)
    self.email = entry['mail'].first
    self.fullname = entry["display_name;lang-#{I18n.default_locale}"]&.first ||
                    entry['display_name']&.first

    # first user is admin
    self.admin = true if User.count.zero?
  end

  def admin?
    admin
  end

  def name
    if fullname&.present?
      fullname
    else
      username
    end
  end

  # def authenticatable_salt
  #   Digest::
  # end
end
