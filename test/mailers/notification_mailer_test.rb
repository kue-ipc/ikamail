require 'test_helper'

require 'nkf'

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @params = {
      user: users(:user01),
      bulk_mail: bulk_mails(:one),
      comment: 'テストコメント',
    }
  end

  test "apply_mail" do
    mail = NotificationMailer.with(**@params).apply_mail
    assert_equal '【一括メールシステム通知】申請', NKF.nkf('-J -w -m', mail.subject)
    assert_equal ["user01@example.jp"], mail.to
    assert_equal ["no-reply@example.jp"], mail.from
    # assert_match "一括", NKF.nkf('-J -w', mail.body.encoded)
    assert_equal read_fixture('apply_mail').join, NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end

  # test "withdraw" do
  #   mail = NotificationMailer.with(**@params).withdraw
  #   assert_equal "Withdraw", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "approve" do
  #   mail = NotificationMailer.with(**@params).approve
  #   assert_equal "Approve", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "reject" do
  #   mail = NotificationMailer.with(**@params).reject
  #   assert_equal "Reject", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "deliver" do
  #   mail = NotificationMailer.with(**@params).deliver
  #   assert_equal "Deliver", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "cancel" do
  #   mail = NotificationMailer.with(**@params).cancel
  #   assert_equal "Cancel", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "discard" do
  #   mail = NotificationMailer.with(**@params).discard
  #   assert_equal "Discard", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "finish" do
  #   mail = NotificationMailer.with(**@params).finish
  #   assert_equal "Finish", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end
  #
  # test "error" do
  #   mail = NotificationMailer.with(**@params).error
  #   assert_equal "Error", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end
