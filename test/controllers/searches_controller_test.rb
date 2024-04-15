require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class SignInAdmin < SearchesControllerTest
    setup do
      sign_in users(:admin)
    end

    test "should get new" do
      get new_search_url
      assert_response :success
    end

    test "redirect to get new INSTEAD OF show seach" do
      get search_url
      assert_redirected_to new_search_path
    end

    test "should create search" do
      post search_url, params: { search: { query: "user01" } }
      assert_response :success
    end
  end

  class SignInUser < SearchesControllerTest
    setup do
      sign_in users(:user01)
    end

    test "should get new" do
      get new_search_url
      assert_response :success
    end

    test "redirect to get new INSTEAD OF show seach" do
      get search_url
      assert_redirected_to new_search_path
    end

    test "should create search" do
      post search_url, params: { search: { query: "user01" } }
      assert_response :success
    end
  end

  class Anonymous < SearchesControllerTest
    test "redirect to login INSTEAD OF get index" do
      get new_search_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to get new INSTEAD OF show seach" do
      get search_url
      assert_redirected_to new_search_path
    end

    test "redirect to login INSTEAD OF get new" do
      post search_url, params: { search: { query: "user01" } }
      assert_redirected_to new_user_session_path
    end
  end
end
