# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :registerable, :recoverable, :validatable
  # and :omniauthable, :lockable, :timeoutable, :trackable
  devise :ldap_authenticatable, :rememberable

  validates :username, presence: true, uniqueness: true, length: {maximum: 255}
  validates :email, presence: true
  validates :fullname, allow_blank: true, length: {maximum: 255}

  has_many :templates, dependent: :restrict_with_exception
  has_many :bulk_mails, dependent: :restrict_with_exception

  def ldap_before_save
    sync_ldap!
    # first user is admin
    self.admin = true if User.count.zero?
  end

  def ldap_entry
    return if deleted

    @ldap_entry ||= Devise::LDAP::Adapter.get_ldap_entry(username)
  end

  def ldap_mail
    ldap_entry&.[]('mail')&.first
  end

  def ldap_display_name
    ldap_entry&.[]("displayName;lang-#{I18n.default_locale}")&.first ||
      ldap_entry&.[]('displayName')&.first
  end

  def sync_ldap!
    return unless ldap_entry

    self.email = ldap_mail
    self.fullname = ldap_display_name
  end

  def admin?
    admin
  end

  def name
    if fullname&.present?
      "#{fullname} (#{username})"
    else
      username
    end
  end

  def to_s
    name
  end
end
