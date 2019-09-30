class RecipientList < ApplicationRecord
  has_and_belongs_to_many :mail_groups
  has_many :manual_users, through: :manual_lists
end
