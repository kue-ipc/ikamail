class MailUser < ApplicationRecord
  has_and_belongs_to_many :mail_groups

  has_many :recipients, dependent: :destroy
  has_and_belongs_to_many :included_recipient_lists,
    class_name: 'RecipientList',
    join_table: 'included_mail_users_recipient_lists'
  has_and_belongs_to_many :excluded_recipient_lists,
    class_name: 'RecipientList',
    join_table: 'excluded_mail_users_recipient_lists'

  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
