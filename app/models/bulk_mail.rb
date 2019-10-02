class BulkMail < ApplicationRecord
  belongs_to :mail_template
  belongs_to :user
  belongs_to :mail_status
end
