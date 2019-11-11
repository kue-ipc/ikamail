require 'test_helper'

class RecipientMailUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_list(:user)
  end

  # test "should get index" do
  #   sign_in users(:admin)
  #   get recipient_list_applicable_mail_users(@recipient_list)
  #   assert_response :success
  #   # get recipient_list_included_mail_users(@recipient_list
  #   # get recipient_list_excluded_mail_users_url(@recipient_list)
  #   # get recipient_mail_users_url
  # end

  # test "should create recipient_mail_user" do
  #   assert_difference('RecipientMailUser.count') do
  #     post recipient_mail_users_url, params: { recipient_mail_user: {  } }
  #   end

  #   assert_redirected_to recipient_mail_user_url(RecipientMailUser.last)
  # end

  # test "should show recipient_mail_user" do
  #   get recipient_mail_user_url(@recipient_mail_user)
  #   assert_response :success
  # end

  # test "should update recipient_mail_user" do
  #   patch recipient_mail_user_url(@recipient_mail_user), params: { recipient_mail_user: {  } }
  #   assert_redirected_to recipient_mail_user_url(@recipient_mail_user)
  # end

  # test "should destroy recipient_mail_user" do
  #   assert_difference('RecipientMailUser.count', -1) do
  #     delete recipient_mail_user_url(@recipient_mail_user)
  #   end

  #   assert_redirected_to recipient_mail_users_url
  # end
end
