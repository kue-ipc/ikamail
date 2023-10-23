require "test_helper"

class ResetCountTemplateJobTest < ActiveJob::TestCase
  test "reset_count_mail_template" do
    assert_equal MailTemplate.find(mail_templates(:users).id).count, 2
    ResetCountTemplateJob.perform_now
    assert_equal MailTemplate.find(mail_templates(:users).id).count, 0
  end
end
