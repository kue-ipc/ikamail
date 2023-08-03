class MailMembership < ApplicationRecord
  belongs_to :mail_user
  belongs_to :mail_group

  validates :mail_user_id, uniqueness: {scope: :mail_group_id}
end
