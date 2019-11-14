# frozen_string_literal: true

require 'test_helper'

class TemplatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @template = templates(:all)
  end

  class SignInAdmin < TemplatesControllerTest
    setup do
      sign_in users(:admin)
    end

    test 'should get index' do
      get templates_url
      assert_response :success
    end

    test 'should get new' do
      get new_template_url
      assert_response :success
    end

    test 'should create template' do
      assert_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}
      end

      assert_redirected_to template_url(Template.last)
    end

    test 'should create NOT template with uncovertible JIS from_name' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name + '😺',
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}
      end

      assert_response :success
    end

    test 'should create NOT template with uncovertible JIS subject_prefix' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix + '😺',
        }}
      end

      assert_response :success
    end

    test 'should create NOT template with uncovertible JIS subject_postfix' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix + '😺',
          subject_prefix: @template.subject_prefix,
        }}
      end

      assert_response :success
    end

    test 'should create NOT template with uncovertible JIS body_header' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header + '😺',
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}
      end

      assert_response :success
    end

    test 'should create NOT template with uncovertible JIS body_footer' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer + '😺',
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}
      end

      assert_response :success
    end

    test 'should show template' do
      get template_url(@template)
      assert_response :success
    end

    test 'should get edit' do
      get edit_template_url(@template)
      assert_response :success
    end

    test 'should update template' do
      patch template_url(@template), params: {template: {
        body_footer: @template.body_footer,
        body_header: @template.body_header,
        count: @template.count,
        description: @template.description,
        from_mail_address: @template.from_mail_address,
        from_name: @template.from_name,
        name: @template.name + '_alt',
        recipient_list_id: @template.recipient_list_id,
        reserved_time: @template.reserved_time,
        subject_postfix: @template.subject_postfix,
        subject_prefix: @template.subject_prefix,
      }}
      assert_redirected_to template_url(@template)
    end

    test 'should NOT destroy template used' do
      assert_no_difference('Template.count') do
        delete template_url(@template)
      end

      assert_redirected_to templates_url
    end

    test 'should destroy template NO used' do
      assert_difference('Template.count', -1) do
        delete template_url(templates(:no_used))
      end

      assert_redirected_to templates_url
    end
  end

  class SignInUser < TemplatesControllerTest
    setup do
      sign_in users(:user01)
    end

    test 'should get index' do
      get templates_url
      assert_response :success
    end

    test 'should NOT get new' do
      assert_raises(Pundit::NotAuthorizedError) do
        get new_template_url
      end
    end

    test 'should NOT create template' do
      assert_no_difference('Template.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          post templates_url, params: {template: {
            body_footer: @template.body_footer,
            body_header: @template.body_header,
            count: @template.count,
            description: @template.description,
            from_mail_address: @template.from_mail_address,
            from_name: @template.from_name,
            name: @template.name + '_alt',
            recipient_list_id: @template.recipient_list_id,
            reserved_time: @template.reserved_time,
            subject_postfix: @template.subject_postfix,
            subject_prefix: @template.subject_prefix,
          }}
        end
      end
    end

    test 'should show template' do
      get template_url(@template)
      assert_response :success
    end

    test 'should NOT get edit' do
      assert_raises(Pundit::NotAuthorizedError) do
        get edit_template_url(@template)
      end
    end

    test 'should NOT update template' do
      assert_raises(Pundit::NotAuthorizedError) do
        patch template_url(@template), params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}
      end
    end

    test 'should NOT destroy template NO used' do
      assert_no_difference('Template.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          delete template_url(templates(:no_used))
        end
      end
    end
  end

  class Anonymous < TemplatesControllerTest
    test 'redirect to login INSTEAD OF get index' do
      get templates_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get new' do
      get new_template_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF create template' do
      assert_no_difference('Template.count') do
        post templates_url, params: {template: {
          body_footer: @template.body_footer,
          body_header: @template.body_header,
          count: @template.count,
          description: @template.description,
          from_mail_address: @template.from_mail_address,
          from_name: @template.from_name,
          name: @template.name + '_alt',
          recipient_list_id: @template.recipient_list_id,
          reserved_time: @template.reserved_time,
          subject_postfix: @template.subject_postfix,
          subject_prefix: @template.subject_prefix,
        }}

      end

      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF show template' do
      get template_url(@template)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get edit' do
      get edit_template_url(@template)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF update template' do
      patch template_url(@template), params: {template: {
        body_footer: @template.body_footer,
        body_header: @template.body_header,
        count: @template.count,
        description: @template.description,
        from_mail_address: @template.from_mail_address,
        from_name: @template.from_name,
        name: @template.name + '_alt',
        recipient_list_id: @template.recipient_list_id,
        reserved_time: @template.reserved_time,
        subject_postfix: @template.subject_postfix,
        subject_prefix: @template.subject_prefix,
      }}
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF destroy template NO used' do
      assert_no_difference('Template.count', -1) do
        delete template_url(templates(:no_used))
      end

      assert_redirected_to new_user_session_path
    end
  end

end
