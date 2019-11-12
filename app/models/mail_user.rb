class MailUser < ApplicationRecord
  has_and_belongs_to_many :mail_groups

  has_many :recipients, dependent: :destroy

  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
