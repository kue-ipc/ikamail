require 'test_helper'

class TemplatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @template = templates(:all)
  end

  test "should get index" do
    sign_in users(:admin)
    get templates_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:admin)
    get new_template_url
    assert_response :success
  end

  test "should create template" do
    sign_in users(:admin)
    assert_difference('Template.count') do
      post templates_url, params: {template: {
        body_footer: @template.body_footer,
        body_header: @template.body_header,
        count: @template.count,
        description: @template.description,
        from_mail_address: @template.from_mail_address,
        from_name: @template.from_name,
        name: @template.name + '_',
        recipient_list_id: @template.recipient_list_id,
        reserved_time: @template.reserved_time,
        subject_postfix: @template.subject_postfix,
        subject_prefix: @template.subject_prefix,
      }}
      
    end

    assert_redirected_to template_url(Template.last)
  end

  test "should show template" do
    sign_in users(:admin)
    get template_url(@template)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_template_url(@template)
    assert_response :success
  end

  test "should update template" do
    sign_in users(:admin)
    patch template_url(@template), params: {template: {
      body_footer: @template.body_footer,
      body_header: @template.body_header,
      count: @template.count,
      description: @template.description,
      from_mail_address: @template.from_mail_address,
      from_name: @template.from_name,
      name: @template.name + '_',
      recipient_list_id: @template.recipient_list_id,
      reserved_time: @template.reserved_time,
      subject_postfix: @template.subject_postfix,
      subject_prefix: @template.subject_prefix,
    }}
    assert_redirected_to template_url(@template)
  end

  # test "should destroy template" do
  #   sign_in users(:admin)
  #   assert_difference('Template.count', -1) do
  #     delete template_url(@template)
  #   end
  #
  #   assert_redirected_to templates_url
  # end
end
