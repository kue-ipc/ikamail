require 'test_helper'

class ReservedDeliveryJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test 'deliver reserved mail' do
    assert_emails 2 do
      ReservedDeliveryJob.perform_now(bulk_mails(:reserved))
    end
  end

  test 'NO deliver pending mail' do
    assert_emails 0 do
      ReservedDeliveryJob.perform_now(bulk_mails(:pending))
    end
  end
end
