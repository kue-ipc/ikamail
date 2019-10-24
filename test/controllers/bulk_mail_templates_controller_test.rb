require 'test_helper'

class BulkMailTemplatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @bulk_mail_template = bulk_mail_templates(:all)
  end

  test "should get index" do
    sign_in users(:admin)
    get bulk_mail_templates_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:admin)
    get new_bulk_mail_template_url
    assert_response :success
  end

  test "should create bulk_mail_template" do
    sign_in users(:admin)
    assert_difference('BulkMailTemplate.count') do
      post bulk_mail_templates_url, params: { bulk_mail_template: {
        body_footer: @bulk_mail_template.body_footer,
        body_header: @bulk_mail_template.body_header,
        count: @bulk_mail_template.count,
        description: @bulk_mail_template.description,
        from_mail_address: @bulk_mail_template.from_mail_address,
        from_name: @bulk_mail_template.from_name,
        name: @bulk_mail_template.name,
        recipient_list: @bulk_mail_template.recipient_list,
        reserved_time: @bulk_mail_template.reserved_time,
        subject_postfix: @bulk_mail_template.subject_postfix,
        subject_prefix: @bulk_mail_template.subject_prefix,
      } }
    end

    assert_redirected_to bulk_mail_template_url(BulkMailTemplate.last)
  end

  test "should show bulk_mail_template" do
    sign_in users(:admin)
    get bulk_mail_template_url(@bulk_mail_template)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_bulk_mail_template_url(@bulk_mail_template)
    assert_response :success
  end

  test "should update bulk_mail_template" do
    sign_in users(:admin)
    patch bulk_mail_template_url(@bulk_mail_template), params: { bulk_mail_template: {
        body_footer: @bulk_mail_template.body_footer,
        body_header: @bulk_mail_template.body_header,
        count: @bulk_mail_template.count,
        description: @bulk_mail_template.description,
        from_mail_address: @bulk_mail_template.from_mail_address,
        from_name: @bulk_mail_template.from_name,
        name: @bulk_mail_template.name,
        recipient_list: @bulk_mail_template.recipient_list,
        reserved_time: @bulk_mail_template.reserved_time,
        subject_postfix: @bulk_mail_template.subject_postfix,
        subject_prefix: @bulk_mail_template.subject_prefix
      } }
    assert_redirected_to bulk_mail_template_url(@bulk_mail_template)
  end

  # test "should destroy bulk_mail_template" do
  #   sign_in users(:admin)
  #   assert_difference('BulkMailTemplate.count', -1) do
  #     delete bulk_mail_template_url(@bulk_mail_template)
  #   end
  #
  #   assert_redirected_to bulk_mail_templates_url
  # end
end
