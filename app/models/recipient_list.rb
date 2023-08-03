class RecipientList < ApplicationRecord
  has_and_belongs_to_many :mail_groups # rubocop: disable Rails/HasAndBelongsToMany
  has_many :mail_templates, dependent: :restrict_with_error

  has_many :recipients, dependent: :destroy
  has_many :mail_users, through: :recipients

  # rubocop: disable Rails/HasManyOrHasOneDependent
  has_many :applicable_recipients, -> { where(excluded: false) }, class_name: 'Recipient', inverse_of: :recipient_list
  has_many :included_recipients, -> { where(included: true) }, class_name: 'Recipient', inverse_of: :recipient_list
  has_many :excluded_recipients, -> { where(excluded: true) }, class_name: 'Recipient', inverse_of: :recipient_list
  has_many :applicable_mail_users, through: :applicable_recipients, source: :mail_user
  has_many :included_mail_users, through: :included_recipients, source: :mail_user
  has_many :excluded_mail_users, through: :excluded_recipients, source: :mail_user
  # rubocop: enable Rails/HasManyOrHasOneDependent

  validates :name, presence: true, uniqueness: {case_sensitive: true}, length: {maximum: 255}
  validates :description, length: {maximum: 65_536}

  def to_s
    name
  end
end
