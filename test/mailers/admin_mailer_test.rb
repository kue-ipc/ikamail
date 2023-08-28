require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "job_failure" do
    mail = AdminMailer.with(job: 'job', job_id: 'job_id', time: 'time', exception: 'exception').job_failure
    assert_equal "【一括メールシステム管理通知】ジョブ失敗", mail.subject
    assert_equal ["admin@example.jp"], mail.to
    assert_equal ["no-reply@example.jp"], mail.from

    assert_match <<~MESSAGE.gsub(/\R/, "\r\n"), mail.body.encoded
      一括メールシステムで、下記のジョブが失敗しました。

      Job: job
      Job ID: job_id
      Time: time
      Exception: exception

      --------------------------------------------------------
      一括メールシステム
      http://ikamail.example.jp/
    MESSAGE
  end

end
