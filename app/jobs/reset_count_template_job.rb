class ResetCountTemplateJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Template.find_each do |template|
      template.update(count: 0)
    end
  end
end
