require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "admin should get top" do
    sign_in users(:admin)
    get root_url
    assert_response :success
  end

  test "user should get top" do
    sign_in users(:user01)
    get root_url
    assert_response :success
  end

  test "should not get top" do
    sign_out :user
    get root_url
    assert_redirected_to new_user_session_path
  end
end
