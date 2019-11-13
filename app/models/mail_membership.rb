# frozen_string_literal: true

class MailMembership < ApplicationRecord
  belongs_to :mail_user
  belongs_to :mail_group
end
