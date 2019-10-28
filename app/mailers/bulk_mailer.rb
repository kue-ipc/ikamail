class BulkMailer < ApplicationMailer
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
      bcc: @bulk_mail.template.recipient_list.mail_users.map(&:mail)
    )
  end

  private
    def before_deliver_bulk_mail
      @bulk_mail = params[:bulk_mail]
      @bulk_mail.update_columns(status: 'delivering', delivery_datetime: Time.current)
    end

    def after_deliver_bulk_mail
      @bulk_mail.update_columns(status: 'delivered', delivery_datetime: Time.current)
    end
end
