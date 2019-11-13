# frozen_string_literal: true

require 'test_helper'

class MailGroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_group = mail_groups(:user)
  end

  test "admin should get index" do
    sign_in users(:admin)
    get mail_groups_url
    assert_response :success
  end

  test "admin should show mail_group" do
    sign_in users(:admin)
    get mail_group_url(@mail_group)
    assert_response :success
  end

  test "user should get index" do
    sign_in users(:user01)
    get mail_groups_url
    assert_response :success
  end

  test "user should show mail_group" do
    sign_in users(:user01)
    get mail_group_url(@mail_group)
    assert_response :success
  end

  # annonymous
  test "should NOT get index" do
    get mail_groups_url
    assert_redirected_to new_user_session_path
  end

  test "should NOT show mail_group" do
    get mail_group_url(@mail_group)
    assert_redirected_to new_user_session_path
  end

end
