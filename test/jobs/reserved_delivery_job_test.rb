require "test_helper"

class ReservedDeliveryJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "deliver reserved mail" do
    assert_emails 2 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved))
    end
  end

  test "NO deliver pending mail" do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:pending))
    end
  end

  test "NO deliver reserved mail whose reserved_at is tomorrow" do
    assert_emails 0 do
      bulk_mails(:reserved).update(reserved_at: Time.current.tomorrow)
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved))
    end
  end
end
