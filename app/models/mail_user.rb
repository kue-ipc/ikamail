class MailUser < ApplicationRecord
  has_and_belongs_to_many :mail_groups
  has_many :recipient_list, through: :manual_lists
end
