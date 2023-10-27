class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail, reservation_number = nil)
    # 最新のBulkMailを取得する
    bulk_mail = BulkMail.find(bulk_mail.id)
    return if bulk_mail.nil?
    # 予約状態ではなくなった場合は終了する。
    return unless bulk_mail.status_reserved?
    # 予約番号が一致しない場合は、終了する。
    return unless bulk_mail.reservation_number == reservation_number

    bulk_mail.with_lock do
      bulk_mail.update!(status: "waiting")
    end

    ActionLog.create(bulk_mail: bulk_mail, action: "deliver", comment: "reserved")
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
