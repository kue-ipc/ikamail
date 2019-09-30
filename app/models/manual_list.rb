class ManualList < ApplicationRecord
  belongs_to :mail_usners
  belongs_to :recipient_list
end
