# frozen_string_literal: true

class ReservedDeliveryJob < ApplicationJob
  queue_as :default

  def perform(bulk_mail_id)
    bulk_mail = BulkMail.find_by(id: bulk_mail_id)
    return if bulk_mail.nil?
    return unless bulk_mail.status_reserved?

    bulk_mail.update_columns(status: 'waiting')
    ActionLog.create(bulk_mail: bulk_mail, action: 'deliver', comment: 'reserved')
    BulkMailer.with(bulk_mail: bulk_mail).all.deliver_later
  end
end
