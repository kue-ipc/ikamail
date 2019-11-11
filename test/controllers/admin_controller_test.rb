require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get top" do
    sign_in users(:admin)
    get admin_root_url
    assert_response :success
  end

  test "should get ldap_sync" do
    sign_in users(:admin)
    put admin_ldap_sync_url
    assert_redirected_to admin_root_path
  end

  # test "should get statistics" do
  #   sign_in users(:admin)
  #   post admin_statistics_url
  #   assert_response :success
  # end

end
