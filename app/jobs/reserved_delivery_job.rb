class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail)
    return if bulk_mail.nil?
    return unless bulk_mail.status_reserved?
    return if bulk_mail.reserved_at.after?(Time.current)

    bulk_mail.update(status: 'waiting')
    ActionLog.create(bulk_mail: bulk_mail, action: 'deliver', comment: 'reserved')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
