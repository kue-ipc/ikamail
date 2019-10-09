require 'test_helper'

class RecipientListsMailUsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @recipient_list = recipient_lists(:all)
  end

  test "should get index" do
    sign_in users(:admin)
    get recipient_list_mail_users_url(@recipient_list)
    assert_response :success
  end

end
