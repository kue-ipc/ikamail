require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "apply" do
    mail = NotificationMailer.apply
    assert_equal "Apply", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "withdraw" do
    mail = NotificationMailer.withdraw
    assert_equal "Withdraw", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "approve" do
    mail = NotificationMailer.approve
    assert_equal "Approve", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reject" do
    mail = NotificationMailer.reject
    assert_equal "Reject", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "deliver" do
    mail = NotificationMailer.deliver
    assert_equal "Deliver", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancel" do
    mail = NotificationMailer.cancel
    assert_equal "Cancel", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "discard" do
    mail = NotificationMailer.discard
    assert_equal "Discard", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "finish" do
    mail = NotificationMailer.finish
    assert_equal "Finish", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "error" do
    mail = NotificationMailer.error
    assert_equal "Error", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
