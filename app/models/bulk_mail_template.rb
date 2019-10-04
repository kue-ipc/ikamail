class BulkMailTemplate < ApplicationRecord
  belongs_to :recipient_list
  has_many :bulk_mail, dependent: :nullify
end
