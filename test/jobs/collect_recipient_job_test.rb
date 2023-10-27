require "test_helper"

class CollectRecipientJobTest < ActiveJob::TestCase
  test "collect recipient" do
    CollectRecipientJob.perform_now(recipient_lists(:all))
    all_recp = RecipientList.find(recipient_lists(:all).id)
    assert_includes all_recp.applicable_mail_users, mail_users(:admin)
    assert_includes all_recp.applicable_mail_users, mail_users(:user01)
    assert_includes all_recp.applicable_mail_users, mail_users(:user02)
    assert_includes all_recp.applicable_mail_users, mail_users(:user03)
    assert all_recp.collected
  end

  test "collect not recipient" do
    CollectRecipientJob.perform_now(recipient_lists(:all_collected))
    all_recp = RecipientList.find(recipient_lists(:all_collected).id)
    assert_not_includes all_recp.applicable_mail_users, mail_users(:admin)
    assert_not_includes all_recp.applicable_mail_users, mail_users(:user01)
    assert_not_includes all_recp.applicable_mail_users, mail_users(:user02)
    assert_not_includes all_recp.applicable_mail_users, mail_users(:user03)
    assert all_recp.collected
  end
end
