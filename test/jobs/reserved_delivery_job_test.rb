require "test_helper"

class ReservedDeliveryJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "deliver reserved mail" do
    assert_emails 2 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved), 42)
    end
  end

  test "NO deliver pending mail" do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:pending), 42)
    end
  end

  test "NO deliver pending mail with reservation number" do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:pending_with_reservation_number), 42)
    end
  end

  test "NO deliver reserved mail with unmatch reservation_number" do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved), 0)
    end
  end
  # for old job

  test "deliver reserved mail without reservation number in old job" do
    assert_emails 2 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved_without_reservation_number))
    end
  end

  test "NO deliver reserved mail with reservation_number in old job" do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved))
    end
  end
end
