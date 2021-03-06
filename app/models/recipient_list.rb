# frozen_string_literal: true

class RecipientList < ApplicationRecord
  has_and_belongs_to_many :mail_groups
  has_many :templates, dependent: :restrict_with_error

  has_many :recipients, dependent: :destroy
  has_many :applicable_recipients, -> { where(excluded: false) }, class_name: 'Recipient'
  has_many :included_recipients, -> { where(included: true) }, class_name: 'Recipient'
  has_many :excluded_recipients, -> { where(excluded: true) }, class_name: 'Recipient'

  has_many :mail_users, through: :recipients
  has_many :applicable_mail_users, through: :applicable_recipients, source: :mail_user
  has_many :included_mail_users, through: :included_recipients, source: :mail_user
  has_many :excluded_mail_users, through: :excluded_recipients, source: :mail_user

  validates :name, presence: true, uniqueness: {case_sensitive: true}, length: {maximum: 255}
  validates :description, length: {maximum: 65536}

  def to_s
    name
  end
end
