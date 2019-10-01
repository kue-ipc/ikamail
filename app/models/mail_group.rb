class MailGroup < ApplicationRecord
  has_and_belongs_to_many :mail_users
  has_and_belongs_to_many :recipient_lists
end