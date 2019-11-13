# frozen_string_literal: true

require 'test_helper'

class ActionLogsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @bulk_mail = bulk_mails(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get bulk_mail_action_logs_url(@bulk_mail)
    assert_response :success
  end

  test "should create action_log" do
    sign_in users(:admin)
    assert_difference('ActionLog.count') do
      post bulk_mail_action_logs_url(@bulk_mail), params: {action_log: {
        action: 'apply',
        comment: '申請',
      }}
    end

    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

end
