class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail)
    # 最新のBulkMailを取得する
    bulk_mail = BulkMail.find(bulk_mail.id)
    return if bulk_mail.nil?
    # 予約状態ではなくなった場合は終了する。
    return unless bulk_mail.status_reserved?
    # 予約時間以降ではない場合は、終了する。ただし、1分の猶予を持つようにする。
    return unless bulk_mail.reserved_at&.<=(Time.current.since(1.minute))

    bulk_mail.with_lock do
      raise 'BulkMail status is not waiting.' unless BulkMail.where(id: bulk_mail.id).pick(:status) == 'waiting'

      bulk_mail.update!(status: 'waiting')
    end

    ActionLog.create(bulk_mail: bulk_mail, action: 'deliver', comment: 'reserved')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
