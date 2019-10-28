require "application_system_test_case"

class ActionLogsTest < ApplicationSystemTestCase
  setup do
    @action_log = action_logs(:one)
  end

  test "visiting the index" do
    visit action_logs_url
    assert_selector "h1", text: "Bulk Mail Actions"
  end

  test "creating a Bulk mail action" do
    visit action_logs_url
    click_on "New Bulk Mail Action"

    fill_in "Action", with: @action_log.action
    fill_in "Bulk mail", with: @action_log.bulk_mail_id
    fill_in "Comment", with: @action_log.comment
    fill_in "User", with: @action_log.user_id
    click_on "Create Bulk mail action"

    assert_text "Bulk mail action was successfully created"
    click_on "Back"
  end

  test "updating a Bulk mail action" do
    visit action_logs_url
    click_on "Edit", match: :first

    fill_in "Action", with: @action_log.action
    fill_in "Bulk mail", with: @action_log.bulk_mail_id
    fill_in "Comment", with: @action_log.comment
    fill_in "User", with: @action_log.user_id
    click_on "Update Bulk mail action"

    assert_text "Bulk mail action was successfully updated"
    click_on "Back"
  end

  test "destroying a Bulk mail action" do
    visit action_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bulk mail action was successfully destroyed"
  end
end
