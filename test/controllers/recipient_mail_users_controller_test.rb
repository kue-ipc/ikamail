require 'test_helper'

class RecipientMailUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipient_mail_user = recipient_mail_users(:one)
  end

  test "should get index" do
    get recipient_mail_users_url
    assert_response :success
  end

  test "should get new" do
    get new_recipient_mail_user_url
    assert_response :success
  end

  test "should create recipient_mail_user" do
    assert_difference('RecipientMailUser.count') do
      post recipient_mail_users_url, params: { recipient_mail_user: {  } }
    end

    assert_redirected_to recipient_mail_user_url(RecipientMailUser.last)
  end

  test "should show recipient_mail_user" do
    get recipient_mail_user_url(@recipient_mail_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_recipient_mail_user_url(@recipient_mail_user)
    assert_response :success
  end

  test "should update recipient_mail_user" do
    patch recipient_mail_user_url(@recipient_mail_user), params: { recipient_mail_user: {  } }
    assert_redirected_to recipient_mail_user_url(@recipient_mail_user)
  end

  test "should destroy recipient_mail_user" do
    assert_difference('RecipientMailUser.count', -1) do
      delete recipient_mail_user_url(@recipient_mail_user)
    end

    assert_redirected_to recipient_mail_users_url
  end
end
