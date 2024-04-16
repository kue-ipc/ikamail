class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :registerable, :recoverable, :validatable
  # and :omniauthable, :lockable, :trackable
  devise :ldap_authenticatable, :rememberable, :timeoutable

  enum role: {user: 0, admin: 1}

  validates :username, presence: true, uniqueness: {case_sensitive: true},
    length: {maximum: 255}
  validates :email, presence: true
  validates :fullname, allow_blank: true, length: {maximum: 255}

  has_many :mail_templates, dependent: :restrict_with_exception
  has_many :bulk_mails, dependent: :restrict_with_exception

  def ldap_before_save
    sync_ldap!
    # The first user is admin
    admin! if User.count.zero?
  end

  def ldap_entry
    return if deleted

    @ldap_entry ||= Devise::LDAP::Adapter.get_ldap_entry(username)
  end

  def ldap_mail
    ldap_entry&.[]("mail")&.first&.downcase
  end

  def ldap_display_name
    ldap_entry&.[]("displayName;lang-#{I18n.default_locale}")&.first ||
      ldap_entry&.[]("displayName")&.first
  end

  def sync_ldap!
    return unless ldap_entry

    self.email = ldap_mail
    self.fullname = ldap_display_name
  end

  def name
    fullname.presence || username
  end

  def deleted?
    deleted
  end

  def to_s
    name
  end
end
