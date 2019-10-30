class CollectRecipientAllJob < ApplicationJob
  queue_as :default

  def perform
    RecipientList.ids.each do |id|
      CollectRecipientJob.perform_later(id)
    end
  end
end
