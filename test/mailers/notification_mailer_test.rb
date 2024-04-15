require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @params = {
      to: users(:user01),
      bulk_mail: bulk_mails(:mail),
      comment: "テストコメント"
    }
  end

  test "mail_apply" do
    mail = NotificationMailer.with(**@params).mail_apply
    assert_equal u8tomjis("【一括メールシステム通知】申込み"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_apply.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_apply two users" do
    mail = NotificationMailer.with(**@params.merge({ to: [ users(:user01),
      users(:user02) ] })).mail_apply
    assert_equal u8tomjis("【一括メールシステム通知】申込み"), mail.subject
    assert_equal [ "user01@example.jp", "user02@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_apply.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_apply nil comment" do
    mail = NotificationMailer.with(**@params.merge({ comment: nil })).mail_apply
    assert_equal u8tomjis("【一括メールシステム通知】申込み"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_apply_no_comment.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_apply empty comment" do
    mail = NotificationMailer.with(**@params.merge({ comment: "" })).mail_apply
    assert_equal u8tomjis("【一括メールシステム通知】申込み"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_apply_no_comment.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_approve immediate" do
    @params[:bulk_mail].delivery_timing = :immediate

    mail = NotificationMailer.with(**@params).mail_approve
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_approve_immediate.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_approve reserved" do
    @params[:bulk_mail].delivery_timing = :reserved

    mail = NotificationMailer.with(**@params).mail_approve
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_approve_reserved.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_approve manual" do
    @params[:bulk_mail].delivery_timing = :manual

    mail = NotificationMailer.with(**@params).mail_approve
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_approve_manual.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_reject" do
    mail = NotificationMailer.with(**@params).mail_reject
    assert_equal u8tomjis("【一括メールシステム通知】受付拒否"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_reject.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_cancel" do
    mail = NotificationMailer.with(**@params).mail_cancel
    assert_equal u8tomjis("【一括メールシステム通知】配信中止"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_cancel.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_finish" do
    mail = NotificationMailer.with(**@params).mail_finish
    assert_equal u8tomjis("【一括メールシステム通知】配信完了"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_finish.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_fail" do
    mail = NotificationMailer.with(**@params).mail_fail
    assert_equal u8tomjis("【一括メールシステム通知】配信失敗"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_fail.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end

  test "mail_error" do
    mail = NotificationMailer.with(**@params).mail_error
    assert_equal u8tomjis("【一括メールシステム通知】エラー"), mail.subject
    assert_equal [ "user01@example.jp" ], mail.to
    assert_equal [ "no-reply@example.jp" ], mail.from
    assert_equal u8tojis(read_fixture("mail_error.text").join.gsub(/\R/, "\r\n")),
      mail.body.encoded
  end
end
