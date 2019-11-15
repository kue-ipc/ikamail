# frozen_string_literal: true

require 'test_helper'

class MailUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @mail_user = mail_users(:user02)
  end

  class SignInAdmin < MailUsersControllerTest
    setup do
      sign_in users(:admin)
    end

    test 'should get index' do
      get mail_users_url
      assert_response :success
    end

    test 'should show mail_user' do
      get mail_user_url(@mail_user)
      assert_response :success
    end
  end

  class SignInUser < MailUsersControllerTest
    setup do
      sign_in users(:user01)
    end

    test 'should get index' do
      get mail_users_url
      assert_response :success
    end

    test 'should show mail_user' do
      get mail_user_url(@mail_user)
      assert_response :success
    end
  end

  class Anonymous < MailUsersControllerTest
    test 'redirect to login INSTEAD OF should get index' do
      get mail_users_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF should show mail_user' do
      get mail_user_url(@mail_user)
      assert_redirected_to new_user_session_path
    end
  end
end
