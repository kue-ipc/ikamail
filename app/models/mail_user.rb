class MailUser < ApplicationRecord
  has_and_belongs_to_many :mail_groups
end
