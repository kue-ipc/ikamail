require "test_helper"
require "helpers/jis_helper"

class BulkMailerTest < ActionMailer::TestCase
  include JisHelper

  test "all" do
    mail = BulkMailer.with(bulk_mail: bulk_mails(:mail)).all
    assert_equal u8tomjis("【全】テスト全ユーザーオール"), mail.subject
    assert_equal ["user01@example.jp", "user03@example.jp"], mail.bcc
    assert_equal ["no-reply@example.jp"], mail.from
    assert_equal u8tojis("前文\nテスト\n全ユーザー宛\n後文\n".gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "delver all" do
    assert_difference("ActionLog.count", 2) do
      # 通知用にもう一つ
      assert_emails 2 do
        BulkMailer.with(bulk_mail: bulk_mails(:mail)).all.deliver_now
      end
    end

    bulk_mail = BulkMail.find(bulk_mails(:mail).id)
    assert_equal "delivered", bulk_mail.status
    assert_not_nil bulk_mail.delivered_at
  end

  test "increment count number" do
    before_mail = BulkMail.find(bulk_mails(:mail).id)
    before_count = before_mail.mail_template.count
    assert_nil before_mail.number
    BulkMailer.with(bulk_mail: bulk_mails(:mail)).all.deliver_now

    after_mail = BulkMail.find(bulk_mails(:mail).id)
    after_count = after_mail.mail_template.count
    assert_equal before_count + 1, after_count
    assert_equal after_count, after_mail.number
  end

  # TODO: delivering状態のメールを送ること自体がおかしいのだが
  test "deliver numbered mail" do
    before_mail = BulkMail.find(bulk_mails(:numbered).id)
    before_count = before_mail.mail_template.count
    assert_equal 6, before_mail.number
    BulkMailer.with(bulk_mail: bulk_mails(:numbered)).all.deliver_now

    after_mail = BulkMail.find(bulk_mails(:numbered).id)
    after_count = after_mail.mail_template.count
    assert_equal before_count, after_count
    assert_equal 6, after_mail.number
  end

  # TODO: delivering状態のメールを送ること自体がおかしいが、
  #       再送処理を整理しきれていないので、とりあえず保留
  test "deliver delivering mail" do
    before_mail = BulkMail.find(bulk_mails(:delivering).id)
    before_count = before_mail.mail_template.count
    assert_equal 1, before_mail.number
    BulkMailer.with(bulk_mail: bulk_mails(:delivering)).all.deliver_now

    after_mail = BulkMail.find(bulk_mails(:delivering).id)
    after_count = after_mail.mail_template.count
    assert_equal before_count, after_count
    assert_equal 1, after_mail.number
  end

  # TODO: delivered状態のメールを送ること自体がおかしいが、
  #       再送処理を整理しきれていないので、とりあえず保留
  test "deliver delivered mail" do
    before_mail = BulkMail.find(bulk_mails(:delivered).id)
    before_count = before_mail.mail_template.count
    assert_equal 2, before_mail.number
    BulkMailer.with(bulk_mail: bulk_mails(:delivered)).all.deliver_now

    after_mail = BulkMail.find(bulk_mails(:delivered).id)
    after_count = after_mail.mail_template.count
    assert_equal before_count, after_count
    assert_equal 2, after_mail.number
  end
end
