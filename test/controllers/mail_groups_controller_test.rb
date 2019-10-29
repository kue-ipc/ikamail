require 'test_helper'

class MailGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mail_group = mail_groups(:one)
  end

  test "should get index" do
    get mail_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_mail_group_url
    assert_response :success
  end

  test "should create mail_group" do
    assert_difference('MailGroup.count') do
      post mail_groups_url, params: { mail_group: { display_name: @mail_group.display_name, name: @mail_group.name } }
    end

    assert_redirected_to mail_group_url(MailGroup.last)
  end

  test "should show mail_group" do
    get mail_group_url(@mail_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_mail_group_url(@mail_group)
    assert_response :success
  end

  test "should update mail_group" do
    patch mail_group_url(@mail_group), params: { mail_group: { display_name: @mail_group.display_name, name: @mail_group.name } }
    assert_redirected_to mail_group_url(@mail_group)
  end

  test "should destroy mail_group" do
    assert_difference('MailGroup.count', -1) do
      delete mail_group_url(@mail_group)
    end

    assert_redirected_to mail_groups_url
  end
end
