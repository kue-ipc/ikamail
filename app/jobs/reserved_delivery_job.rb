class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail)
    return if bulk_mail.nil?

    bulk_mail.with_lock do
      return unless bulk_mail.status_reserved?
      # 1分の猶予を持つようにする。
      return unless bulk_mail.reserved_at&.<=(Time.current.since(1.minute))

      bulk_mail.update!(status: 'waiting')
    end
    ActionLog.create(bulk_mail: bulk_mail, action: 'deliver', comment: 'reserved')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
