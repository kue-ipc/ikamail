# frozen_string_literal: true

class ResetCountTemplateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Template.find_each do |template|
      template.update_column(:count, 0)
    end
  end
end
