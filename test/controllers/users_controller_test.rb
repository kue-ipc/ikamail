require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user02)
  end

  class SignInAdmin < UsersControllerTest
    setup do
      sign_in users(:admin)
    end

    test "should get index" do
      get admin_users_url
      assert_response :success
    end

    test "should create user" do
      assert_difference("User.count") do
        post admin_users_url, params: {user: {
          username: "user04",
        }}
      end
      assert_redirected_to admin_users_url
      assert_equal "ユーザーを登録しました。", flash[:notice]
    end

    test "should NOT create existed user" do
      assert_no_difference("User.count") do
        post admin_users_url, params: {user: {
          username: "user01",
        }}
      end
      assert_redirected_to admin_users_url
      assert_equal "ユーザーを登録することができません。", flash[:alert]
    end

    test "should show user" do
      get admin_user_url(@user)
      assert_response :success
    end

    test "should update user" do
      patch admin_user_url(@user), params: {user: {role: "admin"}}
      assert User.find(@user.id).admin?
      assert_redirected_to admin_users_url
      assert_equal "ユーザーを更新しました。", flash[:notice]
    end

    test "should NOT update own user" do
      patch admin_user_url(users(:admin)), params: {user: {role: "user"}}
      assert User.find(users(:admin).id).admin?
      assert_redirected_to admin_users_url
      assert_equal "自分自身の情報は変更できません。", flash[:alert]
    end

    test "should sync user" do
      assert_enqueued_with(job: LdapUserSyncJob) do
        put sync_admin_users_url
      end
      assert_redirected_to admin_users_url
      assert_equal "LDAP同期を開始しました。", flash[:notice]
    end

    test "should get own user" do
      get user_url
      assert_response :success
    end
  end

  class SignInUser < UsersControllerTest
    setup do
      sign_in users(:user01)
    end

    test "should NOT get index" do
      get admin_users_url
      assert_response :forbidden
    end

    test "should NOT create user" do
      assert_no_difference("User.count") do
        post admin_users_url, params: {user: {
          username: "user04",
        }}
      end
      assert_response :forbidden
    end

    test "should NOT show user" do
      get admin_user_url(@user)
      assert_response :not_found
    end

    test "should NOT update user" do
      patch admin_user_url(@user), params: {user: {role: "admin"}}
      assert_response :not_found
    end

    test "should NOT sync user" do
      assert_no_enqueued_jobs do
        put sync_admin_users_url
      end
      assert_response :forbidden
    end

    test "should get own user" do
      get user_url
      assert_response :success
    end
  end

  class Anonymous < UsersControllerTest
    test "redirect to login INSTEAD OF get index" do
      get admin_users_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF create user" do
      assert_no_difference("User.count") do
        post admin_users_url, params: {user: {
          username: "user04",
        }}
      end
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF show user" do
      get admin_user_url(@user)
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF update user" do
      patch admin_user_url(@user), params: {user: {role: "admin"}}
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF sync user" do
      assert_no_enqueued_jobs do
        put sync_admin_users_url
      end
      assert_redirected_to new_user_session_path
    end

    test "redirect to login instead of get own user" do
      get user_url
      assert_redirected_to new_user_session_path
    end
  end
end
