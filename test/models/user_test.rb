require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "get ldap entry" do
    assert_equal "admin", users(:admin).ldap_entry&.[]("uid")&.first
    assert_equal "user01", users(:user01).ldap_entry&.[]("uid")&.first
  end

  test "NOT get ldap entry" do
    assert_nil users(:unknown).ldap_entry
    assert_nil users(:deleted).ldap_entry
  end
end
