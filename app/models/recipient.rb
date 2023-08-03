class Recipient < ApplicationRecord
  belongs_to :recipient_list
  belongs_to :mail_user

  validates :mail_user_id, uniqueness: {scope: :recipient_list_id}
end
