# frozen_string_literal: true

require 'test_helper'

class RecipientMailUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_lists(:users)
  end

  class SignInAdmin < RecipientMailUsersControllerTest
    setup do
      sign_in users(:admin)
    end

    test 'should get index' do
      get mail_users_recipient_list_url(@recipient_list, 'applicable')
      assert_response :success
    end

    test 'should create recipient_mail_user' do
      assert_difference('Recipient.count') do
        post mail_users_recipient_list_url(@recipient_list, 'included'), params: {name: 'user04'}
      end

      assert_redirected_to recipient_list_url(@recipient_list)
    end

    test 'should destroy recipient_mail_user' do
      assert_difference('Recipient.count', -1) do
        delete mail_user_recipient_list_url(@recipient_list, 'included', mail_users(:admin))
      end

      assert_redirected_to recipient_list_url(@recipient_list)
    end
  end

  class SignInUser < RecipientMailUsersControllerTest
    setup do
      sign_in users(:user01)
    end

    test 'should get index' do
      get mail_users_recipient_list_url(@recipient_list, 'applicable')
      assert_response :success
    end

    test 'should NOT create recipient_mail_user' do
      assert_no_difference('Recipient.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          post mail_users_recipient_list_url(@recipient_list, 'included'), params: {name: 'user04'}
        end
      end
    end

    test 'should NOT destroy recipient_mail_user' do
      assert_no_difference('Recipient.count') do
        assert_raises(Pundit::NotAuthorizedError) do
          delete mail_user_recipient_list_url(@recipient_list, 'included', mail_users(:admin))
        end
      end
    end
  end

  class Anonymous < RecipientMailUsersControllerTest
    test 'redirect to login INSTEAD OF get index' do
      get mail_users_recipient_list_url(@recipient_list, 'applicable')
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF create recipient_mail_user' do
      assert_no_difference('Recipient.count') do
        post mail_users_recipient_list_url(@recipient_list, 'included'), params: {name: 'user04'}
      end

      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF destroy recipient_mail_user' do
      assert_no_difference('Recipient.count') do
        delete mail_user_recipient_list_url(@recipient_list, 'included', mail_users(:admin))
      end

      assert_redirected_to new_user_session_path
    end
  end
end
