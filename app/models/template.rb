require 'iso2022jp'

class Template < ApplicationRecord
  include Iso2022jp

  belongs_to :recipient_list
  belongs_to :user
  has_many :bulk_mail, dependent: :restrict_with_error

  validates :from_name, allow_blank: true, length: {maximum: 255}, charcode: true
  validates :from_mail_address, presence: true, length: {maximum: 255}

  validates :subject_prefix, allow_blank: true, length: {maximum: 255}, charcode: true
  validates :subject_suffix, allow_blank: true, length: {maximum: 255}, charcode: true
  validates :body_header, allow_blank: true, length: {maximum: 65_536}, charcode: true
  validates :body_footer, allow_blank: true, length: {maximum: 65_536}, charcode: true

  validates :reserved_time, presence: true

  before_save :adjust_chars

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

  def next_reserved_datetime
    now_datetime = Time.zone.now
    hm_datetime = now_datetime.change(hour: reserved_time.hour, min: reserved_time.min, zone: reserved_time.zone)
    if hm_datetime < now_datetime
      hm_datetime.tomorrow
    else
      hm_datetime
    end
  end

  private def adjust_chars
    self.from_name = double_conv_jis(from_name)
    self.subject_prefix = double_conv_jis(subject_prefix)
    self.subject_suffix = double_conv_jis(subject_suffix)
    self.body_header = double_conv_jis(body_header)
    self.body_footer = double_conv_jis(body_footer)

    self.body_header += "\n" if body_header.present? && !body_header.end_with?("\n")
    self.body_footer += "\n" if body_footer.present? && !body_footer.end_with?("\n")
  end
end
