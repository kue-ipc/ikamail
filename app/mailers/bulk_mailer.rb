class BulkMailer < ApplicationMailer
  default charset: 'ISO-2022-JP'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bulk_mailer.all.subject
  #
  def all
    @bulk_mail = params[:bulk_mail]

    mail(
      subject: @bulk_mail.subject_all,
      from: @bulk_mail.bulk_mail_template.from,
      bcc: @bulk_mail.bcc
    )
  end

  private
    def finish_bulk_mail
      @bulk_mail..update_columns(status: 'finished', )
    end
end
