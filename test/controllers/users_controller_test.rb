require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user02)
  end

  ## admin
  test "should get index" do
    sign_in users(:admin)
    get admin_users_url
    assert_response :success
  end

  test "should show user" do
    sign_in users(:admin)
    get admin_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    sign_in users(:admin)
    patch admin_user_url(@user), params: {user: {role: 'admin'} }
    assert_redirected_to admin_users_url
  end

  test "admin should get own user" do
    sign_in users(:admin)
    get user_url
    assert_response :success
  end

  ## user
  test "user should NOT get index" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      get admin_users_url
    end
  end

  test "user should NOT show user" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      get admin_user_url(@user)
    end
  end

  test "user should NOT update user" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      patch admin_user_url(@user), params: {user: {role: 'admin'} }
    end
  end

  test "user should get own user" do
    sign_in users(:admin)
    get user_url
    assert_response :success
  end
end
