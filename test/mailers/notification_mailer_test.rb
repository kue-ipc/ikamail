# frozen_string_literal: true

require 'test_helper'

require 'nkf'

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @params = {
      to: users(:user01),
      bulk_mail: bulk_mails(:mail),
      comment: 'テストコメント',
    }
  end

  test 'mail_apply' do
    mail = NotificationMailer.with(**@params).mail_apply
    assert_equal '【一括メールシステム通知】申込み', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_apply.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_apply two users' do
    mail = NotificationMailer.with(**@params.merge({to: [users(:user01), users(:user02)]})).mail_apply
    assert_equal '【一括メールシステム通知】申込み', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp', 'user02@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_apply.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_apply nil comment' do
    mail = NotificationMailer.with(**@params.merge({comment: nil})).mail_apply
    assert_equal '【一括メールシステム通知】申込み', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_apply_no_comment.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_apply empty comment' do
    mail = NotificationMailer.with(**@params.merge({comment: ''})).mail_apply
    assert_equal '【一括メールシステム通知】申込み', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_apply_no_comment.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_approve' do
    mail = NotificationMailer.with(**@params).mail_approve
    assert_equal '【一括メールシステム通知】受付完了', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_approve.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_reject' do
    mail = NotificationMailer.with(**@params).mail_reject
    assert_equal '【一括メールシステム通知】受付拒否', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_reject.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_cancel' do
    mail = NotificationMailer.with(**@params).mail_cancel
    assert_equal '【一括メールシステム通知】配信中止', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_cancel.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_finish' do
    mail = NotificationMailer.with(**@params).mail_finish
    assert_equal '【一括メールシステム通知】配信完了', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_finish.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_fail' do
    mail = NotificationMailer.with(**@params).mail_fail
    assert_equal '【一括メールシステム通知】配信失敗', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_fail.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  test 'mail_error' do
    mail = NotificationMailer.with(**@params).mail_error
    assert_equal '【一括メールシステム通知】エラー', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal read_fixture('mail_error.text').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

end
