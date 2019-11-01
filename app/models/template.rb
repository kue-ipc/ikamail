class Template < ApplicationRecord
  belongs_to :recipient_list
  belongs_to :user
  has_many :bulk_mail, dependent: :restrict_with_error

  validates :from_name, allow_blank: true, length: {maximum: 255}
  validates :from_mail_address, presence: true, length: {maximum: 255}

  def from
    if from_name.present?
      "#{from_name} <#{from_mail_address}>"
    else
      from_mail_address
    end
  end

  def to_s
    name
  end
end
