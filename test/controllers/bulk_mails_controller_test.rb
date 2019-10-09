require 'test_helper'

class BulkMailsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @bulk_mail = bulk_mails(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get bulk_mails_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:admin)
    get new_bulk_mail_url
    assert_response :success
  end

  test "should create bulk_mail" do
    sign_in users(:admin)
    assert_difference('BulkMail.count') do
      post bulk_mails_url, params: { bulk_mail: {
        body: @bulk_mail.body,
        delivery_datetime: @bulk_mail.delivery_datetime,
        mail_status_id: @bulk_mail.mail_status_id,
        mail_template_id: @bulk_mail.mail_template_id,
        number: @bulk_mail.number,
        subject: @bulk_mail.subject,
        user_id: @bulk_mail.user_id
      } }
    end

    assert_redirected_to bulk_mail_url(BulkMail.last)
  end

  test "should show bulk_mail" do
    sign_in users(:admin)
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should update bulk_mail" do
    sign_in users(:admin)
    patch bulk_mail_url(@bulk_mail), params: { bulk_mail: {
      body: @bulk_mail.body,
      delivery_datetime: @bulk_mail.delivery_datetime,
      mail_status_id: @bulk_mail.mail_status_id,
      mail_template_id: @bulk_mail.mail_template_id,
      number: @bulk_mail.number,
      subject: @bulk_mail.subject,
      user_id: @bulk_mail.user_id } }
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should destroy bulk_mail" do
    sign_in users(:admin)
    assert_difference('BulkMail.count', -1) do
      delete bulk_mail_url(@bulk_mail)
    end

    assert_redirected_to bulk_mails_url
  end
end
