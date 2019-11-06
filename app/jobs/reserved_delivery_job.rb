class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail_id)
    bulk_mail = BulkMail.find_by(id: bulk_mial_id)
    return if bulk_mail.nil? || bulk_mail.satus != 'reserved'

    bulk_mail.update_columns(status: 'waiting')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
