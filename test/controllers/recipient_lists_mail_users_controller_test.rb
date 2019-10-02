require 'test_helper'

class RecipientListsMailUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recipient_lists_mail_users_index_url
    assert_response :success
  end

end
