require 'test_helper'

class RecipientListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipient_list = recipient_lists(:one)
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
    assert_difference('RecipientList.count') do
      post recipient_lists_url, params: { recipient_list: { description: @recipient_list.description, display_name: @recipient_list.display_name, name: @recipient_list.name } }
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
    patch recipient_list_url(@recipient_list), params: { recipient_list: { description: @recipient_list.description, display_name: @recipient_list.display_name, name: @recipient_list.name } }
    assert_redirected_to recipient_list_url(@recipient_list)
  end

  test "should destroy recipient_list" do
    assert_difference('RecipientList.count', -1) do
      delete recipient_list_url(@recipient_list)
    end

    assert_redirected_to recipient_lists_url
  end
end
