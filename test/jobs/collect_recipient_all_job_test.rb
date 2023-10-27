require "test_helper"

class CollectRecipientAllJobTest < ActiveJob::TestCase
  test "collect all recipients" do
    assert_enqueued_jobs 4 do
      CollectRecipientAllJob.perform_now
    end
  end
end
