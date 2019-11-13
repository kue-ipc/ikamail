# frozen_string_literal: true

class Recipient < ApplicationRecord
  belongs_to :recipient_list
  belongs_to :mail_user
end
