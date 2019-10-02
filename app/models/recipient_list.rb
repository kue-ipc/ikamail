class RecipientList < ApplicationRecord
  has_and_belongs_to_many :mail_groups
  has_and_belongs_to_many :included_mail_users, class_name: 'MailUser',
    join_table: 'included_mail_users_recipient_lists'
  has_and_belongs_to_many :excluded_mail_users, class_name: 'MailUser',
    join_table: 'excluded_mail_users_recipient_lists'

  def mail_users
    @mail_users ||= (
      mail_groups.map(&:mail_users).sum +
      included_mail_users -
      excluded_mail_users
    ).uniq
  end
end
