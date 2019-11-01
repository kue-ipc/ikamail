class MailGroup < ApplicationRecord
  has_and_belongs_to_many :mail_users
  has_and_belongs_to_many :recipient_lists

  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
