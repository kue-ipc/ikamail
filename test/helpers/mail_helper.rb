require "helpers/jis_helper"

module MailHelper
  include JisHelper

  def read_fixture_mail(filename)
    u8tojis(read_fixture(filename).join.gsub(/\R/, "\r\n"))
  end

  def all_emails_for(bulk_mail)
    bulk_mail.mail_template.recipient_list.applicable_mail_users.map(&:mail)
      .union([bulk_mail.mail_template.user.email, bulk_mail.user.email])
  end
end
