class BulkMailLog < ApplicationRecord
  belongs_to :bulk_mail
  belongs_to :user

  validates :action, inclusion: {in: BulkMail::ACTION_LIST}
end
