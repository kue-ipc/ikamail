require 'test_helper'

class RecipientListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_lists(:all)
  end

  test "admin should get index" do
    sign_in users(:admin)
    get recipient_lists_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:admin)
    get new_recipient_list_url
    assert_response :success
  end

  test "should create recipient_list" do
    sign_in users(:admin)
    assert_difference('RecipientList.count') do
      post recipient_lists_url, params: { recipient_list: {
        name: @recipient_list.name + "2",
        description: @recipient_list.description,
      } }
    end

    assert_redirected_to recipient_list_url(RecipientList.last)
  end

  test "should show recipient_list" do
    sign_in users(:admin)
    get recipient_list_url(@recipient_list)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_recipient_list_url(@recipient_list)
    assert_response :success
  end

  test "should update recipient_list" do
    sign_in users(:admin)
    patch recipient_list_url(@recipient_list), params: { recipient_list: {
      name: @recipient_list.name + "2",
      description: @recipient_list.description,
    } }
    assert_redirected_to recipient_list_url(@recipient_list)
  end

  test "should destroy recipient_list" do
    sign_in users(:admin)
    assert_difference('RecipientList.count', -1) do
      delete recipient_list_url(@recipient_list)
    end

    assert_redirected_to recipient_lists_url
  end

  test "user should get index" do
    sign_in users(:user01)
    get recipient_lists_url
    assert_response :success
  end

  test "should not get index" do
    get recipient_lists_url
    assert_redirected_to new_user_session_path
  end




end
