require 'test_helper'

class RecipientListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_lists(:all)
  end

  ## admin
  test "admin should get index" do
    sign_in users(:admin)
    get recipient_lists_url
    assert_response :success
  end

  test "admin should get new" do
    sign_in users(:admin)
    get new_recipient_list_url
    assert_response :success
  end

  test "admin should create recipient_list" do
    sign_in users(:admin)
    assert_difference('RecipientList.count') do
      post recipient_lists_url, params: { recipient_list: {
        name: @recipient_list.name + "2",
        description: @recipient_list.description,
        mail_group_ids: @recipient_list.mail_group_ids,
      } }
    end

    assert_redirected_to recipient_list_url(RecipientList.last)
  end

  test "admin should show recipient_list" do
    sign_in users(:admin)
    get recipient_list_url(@recipient_list)
    assert_response :success
  end

  test "admin should get edit" do
    sign_in users(:admin)
    get edit_recipient_list_url(@recipient_list)
    assert_response :success
  end

  test "admin should update recipient_list" do
    sign_in users(:admin)
    patch recipient_list_url(@recipient_list), params: { recipient_list: {
      name: @recipient_list.name + "2",
      description: @recipient_list.description,
      mail_group_ids: @recipient_list.mail_group_ids,
    } }
    assert_redirected_to recipient_list_url(@recipient_list)
  end

  test "admin should NOT destroy USED recipient_list" do
    sign_in users(:admin)
    assert_no_difference('RecipientList.count') do
      delete recipient_list_url(@recipient_list)
    end
    assert_response :success
  end

  test "admin should destroy ALONE recipient_list" do
    sign_in users(:admin)
    recipient_list = recipient_lists(:alone)
    assert_difference('RecipientList.count', -1) do
      delete recipient_list_url(recipient_list)
    end
    assert_redirected_to recipient_lists_url
  end

  ## user
  test "user should get index" do
    sign_in users(:user01)
    get recipient_lists_url
    assert_response :success
  end

  test "user should NOT get new" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      get new_recipient_list_url
    end
    # assert_response :forbidden
  end

  test "user should NOT create recipient_list" do
    sign_in users(:user01)
    assert_no_difference('RecipientList.count') do
      assert_raises(Pundit::NotAuthorizedError) do
        post recipient_lists_url, params: { recipient_list: {
          name: @recipient_list.name + "2",
          description: @recipient_list.description,
          mail_group_ids: @recipient_list.mail_group_ids,
        } }
      end
    end
    # assert_response :forbidden
  end

  test "user should show recipient_list" do
    sign_in users(:user01)
    get recipient_list_url(@recipient_list)
    assert_response :success
  end

  test "user should NOT get edit" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_recipient_list_url(@recipient_list)
    end
    # assert_response :forbidden
  end

  test "user should NOT update recipient_list" do
    sign_in users(:user01)
    assert_raises(Pundit::NotAuthorizedError) do
      patch recipient_list_url(@recipient_list), params: { recipient_list: {
        name: @recipient_list.name + "2",
        description: @recipient_list.description,
        mail_group_ids: @recipient_list.mail_group_ids,
      } }
    end
    # assert_response :forbidden
  end

  test "user should NOT destroy ALONE recipient_list" do
    sign_in users(:user01)
    recipient_list = recipient_lists(:alone)
    assert_no_difference('RecipientList.count') do
      assert_raises(Pundit::NotAuthorizedError) do
        delete recipient_list_url(recipient_list)
      end
    end
    # assert_response :forbidden
  end

  ## anonymouse
  test "should NOT get index" do
    get recipient_lists_url
    assert_redirected_to new_user_session_path
  end

  test "should NOT get new" do
    get new_recipient_list_url
    assert_redirected_to new_user_session_path
  end

  test "should NOT create recipient_list" do
    assert_no_difference('RecipientList.count') do
      post recipient_lists_url, params: { recipient_list: {
        name: @recipient_list.name + "2",
        description: @recipient_list.description,
        mail_group_ids: @recipient_list.mail_group_ids,
      } }
    end
    assert_redirected_to new_user_session_path
  end

  test "should NOT show recipient_list" do
    get recipient_list_url(@recipient_list)
    assert_redirected_to new_user_session_path
  end

  test "should NOT get edit" do
    get edit_recipient_list_url(@recipient_list)
    assert_redirected_to new_user_session_path
  end

  test "should NOT update recipient_list" do
    patch recipient_list_url(@recipient_list), params: { recipient_list: {
      name: @recipient_list.name + "2",
      description: @recipient_list.description,
      mail_group_ids: @recipient_list.mail_group_ids,
    } }
    assert_redirected_to new_user_session_path
  end

  test "should NOT destroy ALONE recipient_list" do
    recipient_list = recipient_lists(:alone)
    assert_no_difference('RecipientList.count') do
      delete recipient_list_url(recipient_list)
    end
    assert_redirected_to new_user_session_path
  end

end
