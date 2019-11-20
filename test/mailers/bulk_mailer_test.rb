# frozen_string_literal: true

require 'test_helper'

class BulkMailerTest < ActionMailer::TestCase
  test "all" do
    mail = BulkMailer.with(bulk_mail: bulk_mails(:draft_mail)).all
    assert_equal '【全】テスト全ユーザーオール', NKF.nkf('-J -w -m', mail.subject)
    # assert_equal ['user01@example.jp'], mail.to
    assert_equal ['no-reply@example.jp'], mail.from
    assert_equal "前文\nテスト\n全ユーザー宛\n後文\n",
                 NKF.nkf('-J -w', mail.body.encoded).gsub("\r\n", "\n")
  end
end
