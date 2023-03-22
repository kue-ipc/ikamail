require 'test_helper'

class BulkMailerTest < ActionMailer::TestCase
  test 'all' do
    mail = BulkMailer.with(bulk_mail: bulk_mails(:mail)).all
    assert_equal u8tomjis('【全】テスト全ユーザーオール'), mail.subject
    assert_equal ['user01@example.jp', 'user03@example.jp'], mail.bcc
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal u8tojis("前文\nテスト\n全ユーザー宛\n後文\n".gsub(/\R/, "\r\n")), mail.body.encoded
  end

  test 'delver all' do
    assert_difference('ActionLog.count', 2) do
      # 通知用にもう一つ
      assert_emails 2 do
        BulkMailer.with(bulk_mail: bulk_mails(:mail)).all.deliver_now
      end
    end

    bulk_mail = BulkMail.find(bulk_mails(:mail).id)
    assert_equal 'delivered', bulk_mail.status
    assert_not_nil bulk_mail.delivered_at
  end
end
