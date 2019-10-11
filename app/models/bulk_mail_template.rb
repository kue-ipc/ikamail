class BulkMailTemplate < ApplicationRecord
  belongs_to :recipient_list
  belongs_to :user
  has_many :bulk_mail, dependent: :restrict_with_error
end