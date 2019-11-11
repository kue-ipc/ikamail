require 'test_helper'

class BulkMailerTest < ActionMailer::TestCase
  test "all" do
    mail = BulkMailer.with(bulk_mail: bulk_mails(:one)).all
    assert_equal 'テスト全ユーザー', NKF.nkf('-J -w -m', mail.subject)
    # assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal "テスト\n全ユーザー宛\n",
                 NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end
end
