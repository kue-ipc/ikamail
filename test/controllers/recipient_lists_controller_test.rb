require "test_helper"

class RecipientListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_lists(:all)
  end

  class SignInAdmin < RecipientListsControllerTest
    setup do
      sign_in users(:admin)
    end

    test "should get index" do
      get recipient_lists_url
      assert_response :success
    end

    test "should get new" do
      get new_recipient_list_url
      assert_response :success
    end

    test "should create recipient_list" do
      assert_difference("RecipientList.count") do
        post recipient_lists_url, params: {recipient_list: {
          name: "#{@recipient_list.name}_alt",
          description: @recipient_list.description,
          mail_group_ids: @recipient_list.mail_group_ids,
        }}
      end

      assert_redirected_to recipient_list_url(RecipientList.last)
    end

    test "should show recipient_list" do
      get recipient_list_url(@recipient_list)
      assert_response :success
    end

    test "should get edit" do
      get edit_recipient_list_url(@recipient_list)
      assert_response :success
    end

    test "should update recipient_list" do
      patch recipient_list_url(@recipient_list), params: {recipient_list: {
        name: "#{@recipient_list.name}_alt",
        description: @recipient_list.description,
        mail_group_ids: @recipient_list.mail_group_ids,
      }}
      assert_redirected_to recipient_list_url(@recipient_list)
    end

    test "should NOT destroy USED recipient_list" do
      assert_no_difference("RecipientList.count") do
        delete recipient_list_url(@recipient_list)
      end
      assert_response :success
    end

    test "should destroy ALONE recipient_list" do
      recipient_list = recipient_lists(:alone)
      assert_difference("RecipientList.count", -1) do
        delete recipient_list_url(recipient_list)
      end
      assert_redirected_to recipient_lists_url
    end
  end

  class SignInUser < RecipientListsControllerTest
    setup do
      sign_in users(:user01)
    end

    test "should get index" do
      get recipient_lists_url
      assert_response :success
    end

    test "should NOT get new" do
      assert_raises(Pundit::NotAuthorizedError) do
        get new_recipient_list_url
      end
      # assert_response :forbidden
    end

    test "should NOT create recipient_list" do
      assert_no_difference("RecipientList.count") do
        assert_raises(Pundit::NotAuthorizedError) do
          post recipient_lists_url, params: {recipient_list: {
            name: "#{@recipient_list.name}_alt",
            description: @recipient_list.description,
            mail_group_ids: @recipient_list.mail_group_ids,
          }}
        end
      end
      # assert_response :forbidden
    end

    test "should show recipient_list" do
      get recipient_list_url(@recipient_list)
      assert_response :success
    end

    test "should NOT get edit" do
      assert_raises(Pundit::NotAuthorizedError) do
        get edit_recipient_list_url(@recipient_list)
      end
      # assert_response :forbidden
    end

    test "should NOT update recipient_list" do
      assert_raises(Pundit::NotAuthorizedError) do
        patch recipient_list_url(@recipient_list), params: {recipient_list: {
          name: "#{@recipient_list.name}_alt",
          description: @recipient_list.description,
          mail_group_ids: @recipient_list.mail_group_ids,
        }}
      end
      # assert_response :forbidden
    end

    test "should NOT destroy ALONE recipient_list" do
      recipient_list = recipient_lists(:alone)
      assert_no_difference("RecipientList.count") do
        assert_raises(Pundit::NotAuthorizedError) do
          delete recipient_list_url(recipient_list)
        end
      end
      # assert_response :forbidden
    end
  end

  class Anonymous < RecipientListsControllerTest
    test "redirect to login INSTEAD OF  get index" do
      get recipient_lists_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF get new" do
      get new_recipient_list_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF create recipient_list" do
      assert_no_difference("RecipientList.count") do
        post recipient_lists_url, params: {recipient_list: {
          name: "#{@recipient_list.name}_alt",
          description: @recipient_list.description,
          mail_group_ids: @recipient_list.mail_group_ids,
        }}
      end
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF show recipient_list" do
      get recipient_list_url(@recipient_list)
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF get edit" do
      get edit_recipient_list_url(@recipient_list)
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF update recipient_list" do
      patch recipient_list_url(@recipient_list), params: {recipient_list: {
        name: "#{@recipient_list.name}_alt",
        description: @recipient_list.description,
        mail_group_ids: @recipient_list.mail_group_ids,
      }}
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF destroy ALONE recipient_list" do
      recipient_list = recipient_lists(:alone)
      assert_no_difference("RecipientList.count") do
        delete recipient_list_url(recipient_list)
      end
      assert_redirected_to new_user_session_path
    end
  end
end
