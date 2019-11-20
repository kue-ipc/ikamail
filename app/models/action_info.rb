# frozen_string_literal: true

class ActionInfo
  include ActiveModel::Model
  attr_accessor :comment, :current_status, :datetime
end
