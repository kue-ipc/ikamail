require "test_helper"

class MailGroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_group = mail_groups(:user)
  end

  class SignInAdmin < MailGroupsControllerTest
    setup do
      sign_in users(:admin)
    end

    test "should get index" do
      get mail_groups_url
      assert_response :success
    end

    test "should show mail_group" do
      get mail_group_url(@mail_group)
      assert_response :success
    end
  end

  class SignInUser < MailGroupsControllerTest
    setup do
      sign_in users(:user01)
    end

    test "should NOT get index" do
      get mail_groups_url
      assert_response :forbidden
    end

    test "should NOT show mail_group" do
      get mail_group_url(@mail_group)
      assert_response :not_found
    end
  end

  class Anonymous < MailGroupsControllerTest
    test "redirect to login INSTEAD OF get index" do
      get mail_groups_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF show mail_group" do
      get mail_group_url(@mail_group)
      assert_redirected_to new_user_session_path
    end
  end
end
