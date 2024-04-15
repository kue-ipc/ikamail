class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail, reservation_number = nil)
    unless bulk_mail.status_reserved?
      # 予約状態ではなくなった場合は実行しない。
      logger.info "Skip job because status of the bulk_maili (ID: #{bulk_mail.id}) is not reserved."
      return
    end
    unless bulk_mail.reservation_number == reservation_number
      # 予約番号が一致しない場合は実行しない。
      logger.info "Skip job because reservation_number of the bulk_maili (ID: #{bulk_mail.id}) is not match."
      return
    end

    bulk_mail.update!(status: "waiting")

    ActionLog.create(bulk_mail: bulk_mail, action: "deliver",
      comment: "reserved")
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
