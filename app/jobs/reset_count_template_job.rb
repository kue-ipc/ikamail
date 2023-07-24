class ResetCountTemplateJob < ApplicationJob
  queue_as :default

  def perform
    MailTemplate.find_each do |mail_template|
      mail_template.update(count: 0)
    end
  end
end
