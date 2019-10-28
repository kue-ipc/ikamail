require 'test_helper'

class BulkMailerTest < ActionMailer::TestCase
  test "all" do
    mail = BulkMailer.all
    assert_equal "All", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
