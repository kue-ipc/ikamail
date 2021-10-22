class ResetCountTemplateJob < ApplicationJob
  queue_as :default

  def perform
    Template.find_each do |template|
      template.update(count: 0)
    end
  end
end
