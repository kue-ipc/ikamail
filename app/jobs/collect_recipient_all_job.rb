class CollectRecipientAllJob < ApplicationJob
  queue_as :default

  def perform
    RecipientList.find_each do |recipient_list|
      recipient_list.update(collected: false)
      CollectRecipientJob.perform_later(recipient_list)
    end
  end
end
