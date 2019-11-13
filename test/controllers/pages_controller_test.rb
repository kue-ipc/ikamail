# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class SignInAdmin < PagesControllerTest
    setup do
      sign_in users(:admin)
    end

    test 'should get top' do
      get root_url
      assert_response :success
    end
  end

  class SignInUser < PagesControllerTest
    setup do
      sign_in users(:user01)
    end

    test 'should NOT get top' do
      get root_url
      assert_response :success
    end
  end

  class Anonymous < PagesControllerTest
    test 'redirect to login INSTEAD OF get top' do
      get root_url
      assert_redirected_to new_user_session_path
    end
  end
end
