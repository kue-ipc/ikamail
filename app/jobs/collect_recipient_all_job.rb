class CollectRecipientAllJob < ApplicationJob
  queue_as :default

  def perform
    RecipientList.find_each do |recipient_list|
      CollectRecipientJob.perform_later(recipient_list)
    end
  end
end
