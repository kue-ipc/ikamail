# frozen_string_literal: true

class BulkMailer < ApplicationMailer
  layout 'empty_mailer'

  default charset: 'ISO-2022-JP'

  before_action :before_deliver_bulk_mail
  after_action :after_deliver_bulk_mail

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bulk_mailer.all.subject
  #
  def all
    mail(
      subject: @bulk_mail.subject_all,
      from: @bulk_mail.template.from,
      bcc: @bulk_mail.template.recipient_list.applicable_mail_users.map(&:mail) +
        [@bulk_mail.template.user.email, @bulk_mail.user.email]
    )
  end

  private

    def before_deliver_bulk_mail
      @bulk_mail = params[:bulk_mail]
      @bulk_mail.update_columns(status: 'delivering')
      ActionLog.create(bulk_mail: @bulk_mail, action: 'start')
    end

    def after_deliver_bulk_mail
      @bulk_mail.update_columns(status: 'delivered', delivered_at: Time.zone.now)
      ActionLog.create(bulk_mail: @bulk_mail, action: 'finish')
      NotificationMailer.with(to: @bulk_mail.user, bulk_mail: @bulk_mail).mail_finish.deliver_later
    end
end
