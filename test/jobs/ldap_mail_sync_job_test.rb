require "test_helper"

class LdapMailSyncJobTest < ActiveJob::TestCase
  test "sync mail user" do
    LdapMailSyncJob.perform_now
    assert_equal "名無し　権兵衛", MailUser.find_by(name: "user04")&.display_name
    assert_equal "user05@example.jp", MailUser.find_by(name: "user05")&.mail
    assert_not_nil MailUser.find_by(name: "user06")
  end

  test "sync mail group" do
    LdapMailSyncJob.perform_now
    assert_not_nil MailGroup.find_by(name: "staff")
    assert_nil MailGroup.find_by(name: "unknown")
  end

  test "sync mail member" do
    LdapMailSyncJob.perform_now
    admin_users = MailGroup.find_by(name: "admin")&.mail_users&.map(&:name)&.sort
    staff_users = MailGroup.find_by(name: "staff")&.mail_users&.map(&:name)&.sort
    user_users = MailGroup.find_by(name: "user")&.mail_users&.map(&:name)&.sort

    assert_equal ["admin"].sort, admin_users
    assert_equal ["user01", "user02"].sort, staff_users
    assert_equal(%w[user01 user03 user04 user05 user06].sort, user_users.reject { |name| name.start_with?("test") })
  end

  test "enqueu collect all recipients after sync" do
    assert_enqueued_with(job: CollectRecipientAllJob) do
      LdapMailSyncJob.perform_now
    end
  end
end
