require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get admin_top_url
    assert_response :success
  end

  test "should get ldap_sync" do
    get admin_ldap_sync_url
    assert_response :success
  end

  test "should get statistics" do
    get admin_statistics_url
    assert_response :success
  end

end
