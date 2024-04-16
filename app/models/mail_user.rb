class MailUser < ApplicationRecord
  has_many :mail_memberships, dependent: :destroy
  has_many :mail_groups, -> { distinct }, through: :mail_memberships
  has_many :recipients, dependent: :destroy
  has_many :recipient_lists, through: :recipients

  # rubocop: disable Rails/HasManyOrHasOneDependent
  has_many :primary_memberships, -> { where(primary: true) },
    class_name: "MailMembership", inverse_of: :mail_user
  has_many :secondary_memberships, -> { where(primary: false) },
    class_name: "MailMembership", inverse_of: :mail_user
  has_many :primary_groups, through: :primary_memberships, source: :mail_group
  has_many :secondary_groups, through: :secondary_memberships,
    source: :mail_group
  has_many :applicable_recipients, -> { where(excluded: false) },
    class_name: "Recipient", inverse_of: :mail_user
  has_many :applicable_recipient_lists, through: :applicable_recipients,
    source: :recipient_list
  # rubocop: enable Rails/HasManyOrHasOneDependent

  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
