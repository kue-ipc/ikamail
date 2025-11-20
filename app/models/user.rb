class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :trackable and :omniauthable
  # :registerable, :recoverable, :validatable
  devise :ldap_authenticatable, :rememberable, :lockable, :timeoutable

  enum :role, {user: 0, admin: 1}

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

    unless @ldap_entry_has
      @ldap_entry = Devise::LDAP::Adapter.get_ldap_entry(username)
      @ldap_entry_has = true
    end
    @ldap_entry
  end

  def ldap_param(name, multi: false)
    if multi
      ldap_entry&.[](name)
    else
      ldap_entry&.first(name)
    end
  end

  def ldap_mail
    ldap_param("mail")&.downcase
  end

  def ldap_display_name
    list = ["displayName"]
    list << "displayName;lang-#{I18n.default_locale}"
    list << "jaDisplayName" if I18n.default_locale == :ja
    list.each do |name|
      ldap_param(name).presence&.then { |value| return value }
    end
    nil
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
