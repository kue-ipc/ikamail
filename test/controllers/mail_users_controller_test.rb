require 'test_helper'

class MailUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_user = mail_users(:user02)
  end

  test "admin should get index" do
    sign_in users(:admin)
    get mail_users_url
    assert_response :success
  end

  test "admin should show mail_user" do
    sign_in users(:admin)
    get mail_user_url(@mail_user)
    assert_response :success
  end

end
