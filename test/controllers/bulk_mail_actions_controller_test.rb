require 'test_helper'

class BulkMailActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulk_mail_action = bulk_mail_actions(:one)
  end

  test "should get index" do
    get bulk_mail_actions_url
    assert_response :success
  end

  test "should get new" do
    get new_bulk_mail_action_url
    assert_response :success
  end

  test "should create bulk_mail_action" do
    assert_difference('BulkMailAction.count') do
      post bulk_mail_actions_url, params: { bulk_mail_action: { action: @bulk_mail_action.action, bulk_mail_id: @bulk_mail_action.bulk_mail_id, comment: @bulk_mail_action.comment, user_id: @bulk_mail_action.user_id } }
    end

    assert_redirected_to bulk_mail_action_url(BulkMailAction.last)
  end

  test "should show bulk_mail_action" do
    get bulk_mail_action_url(@bulk_mail_action)
    assert_response :success
  end

  test "should get edit" do
    get edit_bulk_mail_action_url(@bulk_mail_action)
    assert_response :success
  end

  test "should update bulk_mail_action" do
    patch bulk_mail_action_url(@bulk_mail_action), params: { bulk_mail_action: { action: @bulk_mail_action.action, bulk_mail_id: @bulk_mail_action.bulk_mail_id, comment: @bulk_mail_action.comment, user_id: @bulk_mail_action.user_id } }
    assert_redirected_to bulk_mail_action_url(@bulk_mail_action)
  end

  test "should destroy bulk_mail_action" do
    assert_difference('BulkMailAction.count', -1) do
      delete bulk_mail_action_url(@bulk_mail_action)
    end

    assert_redirected_to bulk_mail_actions_url
  end
end
