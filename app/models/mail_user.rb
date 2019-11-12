# frozen_string_literal: true

class MailUser < ApplicationRecord
  has_many :recipients, dependent: :destroy

  has_many :mail_memberships, dependent: :destroy
  has_many :primary_memberships, -> { where(primary: true) }, class_name: 'MailMembership'
  has_many :secondary_memberships, -> { where(primary: false) }, class_name: 'MailMembership'

  has_many :mail_groups, through: :mail_memberships
  has_many :primary_groups, through: :primary_memberships, source: :mail_group
  has_many :secondary_groups, through: :secondary_memberships, source: :mail_group

  # has_and_belongs_to_many :mail_groups


  def to_s
    if display_name.present?
      "#{display_name} (#{name})"
    else
      name
    end
  end
end
