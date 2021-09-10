require 'test_helper'

class ResetCountTemplateJobTest < ActiveJob::TestCase
  test 'reset_count_template' do
    assert_equal Template.find(templates(:users).id).count, 2
    ResetCountTemplateJob.perform_now
    assert_equal Template.find(templates(:users).id).count, 0
  end
end
