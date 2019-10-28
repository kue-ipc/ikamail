class ActionLog < ApplicationRecord
  belongs_to :bulk_mail
  belongs_to :user
end
