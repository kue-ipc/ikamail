class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail)
    return if bulk_mail.nil?
    return unless bulk_mail.status_reserved?
    # 1分の猶予を持つようにする。
    return unless bulk_mail.reserved_at&.<=(Time.current.ago(1.minute))

    bulk_mail.update(status: 'waiting')
    ActionLog.create(bulk_mail: bulk_mail, action: 'deliver', comment: 'reserved')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
