class MailTemplate < ApplicationRecord
  belongs_to :recipient_list
  has_many :bulk_mail
end
