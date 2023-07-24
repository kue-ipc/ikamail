require 'test_helper'

class MailTemplatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_template = mail_templates(:all)
  end

  class SignInAdmin < MailTemplatesControllerTest
    setup do
      sign_in users(:admin)
    end

    test 'should get index' do
      get mail_templates_url
      assert_response :success
    end

    test 'should get new' do
      get new_template_url
      assert_response :success
    end

    test 'should create mail_template' do
      assert_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_redirected_to mail_template_url(MailTemplate.last)
    end

    test 'should create NOT mail_template with uncovertible JIS from_name' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: "#{@mail_template.from_name}😺",
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_response :success
    end

    test 'should create NOT mail_template with uncovertible JIS subject_prefix' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: "#{@mail_template.subject_prefix}😺",
          user: {username: @mail_template.user.username},
        }}
      end

      assert_response :success
    end

    test 'should create NOT mail_template with uncovertible JIS subject_suffix' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: "#{@mail_template.subject_suffix}😺",
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_response :success
    end

    test 'should create NOT mail_template with uncovertible JIS body_header' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: "#{@mail_template.body_header}😺",
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_response :success
    end

    test 'should create NOT mail_template with uncovertible JIS body_footer' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: "#{@mail_template.body_footer}😺",
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_response :success
    end

    test 'should show mail_template' do
      get mail_template_url(@mail_template)
      assert_response :success
    end

    test 'should get edit' do
      get edit_template_url(@mail_template)
      assert_response :success
    end

    test 'should update mail_template' do
      patch mail_template_url(@mail_template), params: {mail_template: {
        body_footer: @mail_template.body_footer,
        body_header: @mail_template.body_header,
        description: @mail_template.description,
        from_mail_address: @mail_template.from_mail_address,
        from_name: @mail_template.from_name,
        name: "#{@mail_template.name}_alt",
        recipient_list_id: @mail_template.recipient_list_id,
        reserved_time: @mail_template.reserved_time,
        subject_suffix: @mail_template.subject_suffix,
        subject_prefix: @mail_template.subject_prefix,
        user: {username: @mail_template.user.username},
      }}
      assert_redirected_to mail_template_url(@mail_template)
    end

    test 'should NOT destroy mail_template used' do
      assert_no_difference('MailTemplate.count') do
        delete mail_template_url(@mail_template)
      end

      assert_redirected_to mail_templates_url
    end

    test 'should destroy mail_template NO used' do
      assert_difference('MailTemplate.count', -1) do
        delete mail_template_url(mail_templates(:no_used))
      end

      assert_redirected_to mail_templates_url
    end
  end

  class SignInUser < MailTemplatesControllerTest
    setup do
      sign_in users(:user01)
    end

    test 'should get index' do
      get mail_templates_url
      assert_response :success
    end

    test 'should NOT get new' do
      assert_raises(Pundit::NotAuthorizedError) do
        get new_template_url
      end
    end

    test 'should NOT create mail_template' do
      assert_no_difference('MailTemplate.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          post mail_templates_url, params: {mail_template: {
            body_footer: @mail_template.body_footer,
            body_header: @mail_template.body_header,
            description: @mail_template.description,
            from_mail_address: @mail_template.from_mail_address,
            from_name: @mail_template.from_name,
            name: "#{@mail_template.name}_alt",
            recipient_list_id: @mail_template.recipient_list_id,
            reserved_time: @mail_template.reserved_time,
            subject_suffix: @mail_template.subject_suffix,
            subject_prefix: @mail_template.subject_prefix,
            user: {username: @mail_template.user.username},
          }}
        end
      end
    end

    test 'should show mail_template' do
      get mail_template_url(@mail_template)
      assert_response :success
    end

    test 'should NOT get edit' do
      assert_raises(Pundit::NotAuthorizedError) do
        get edit_template_url(@mail_template)
      end
    end

    test 'should NOT update mail_template' do
      assert_raises(Pundit::NotAuthorizedError) do
        patch mail_template_url(@mail_template), params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end
    end

    test 'should NOT destroy mail_template NO used' do
      assert_no_difference('MailTemplate.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          delete mail_template_url(mail_templates(:no_used))
        end
      end
    end
  end

  class Anonymous < MailTemplatesControllerTest
    test 'redirect to login INSTEAD OF get index' do
      get mail_templates_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get new' do
      get new_template_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF create mail_template' do
      assert_no_difference('MailTemplate.count') do
        post mail_templates_url, params: {mail_template: {
          body_footer: @mail_template.body_footer,
          body_header: @mail_template.body_header,
          description: @mail_template.description,
          from_mail_address: @mail_template.from_mail_address,
          from_name: @mail_template.from_name,
          name: "#{@mail_template.name}_alt",
          recipient_list_id: @mail_template.recipient_list_id,
          reserved_time: @mail_template.reserved_time,
          subject_suffix: @mail_template.subject_suffix,
          subject_prefix: @mail_template.subject_prefix,
          user: {username: @mail_template.user.username},
        }}
      end

      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF show mail_template' do
      get mail_template_url(@mail_template)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get edit' do
      get edit_template_url(@mail_template)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF update mail_template' do
      patch mail_template_url(@mail_template), params: {mail_template: {
        body_footer: @mail_template.body_footer,
        body_header: @mail_template.body_header,
        description: @mail_template.description,
        from_mail_address: @mail_template.from_mail_address,
        from_name: @mail_template.from_name,
        name: "#{@mail_template.name}_alt",
        recipient_list_id: @mail_template.recipient_list_id,
        reserved_time: @mail_template.reserved_time,
        subject_suffix: @mail_template.subject_suffix,
        subject_prefix: @mail_template.subject_prefix,
        user: {username: @mail_template.user.username},
      }}
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF destroy mail_template NO used' do
      assert_no_difference('MailTemplate.count', -1) do
        delete mail_template_url(mail_templates(:no_used))
      end

      assert_redirected_to new_user_session_path
    end
  end
end
