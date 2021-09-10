class MailGroup < ApplicationRecord
  has_and_belongs_to_many :recipient_lists

  has_many :mail_memberships, dependent: :destroy
  has_many :primary_memberships, -> { where(primary: true) }, class_name: 'MailMembership'
  has_many :secondary_memberships, -> { where(primary: false) }, class_name: 'MailMembership'

  has_many :mail_users, through: :mail_memberships
  has_many :primary_users, through: :primary_memberships, source: :mail_user
  has_many :secondary_users, through: :secondary_memberships, source: :mail_user

  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
