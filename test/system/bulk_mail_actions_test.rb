require "application_system_test_case"

class BulkMailActionsTest < ApplicationSystemTestCase
  setup do
    @bulk_mail_action = bulk_mail_actions(:one)
  end

  test "visiting the index" do
    visit bulk_mail_actions_url
    assert_selector "h1", text: "Bulk Mail Actions"
  end

  test "creating a Bulk mail action" do
    visit bulk_mail_actions_url
    click_on "New Bulk Mail Action"

    fill_in "Action", with: @bulk_mail_action.action
    fill_in "Bulk mail", with: @bulk_mail_action.bulk_mail_id
    fill_in "Comment", with: @bulk_mail_action.comment
    fill_in "User", with: @bulk_mail_action.user_id
    click_on "Create Bulk mail action"

    assert_text "Bulk mail action was successfully created"
    click_on "Back"
  end

  test "updating a Bulk mail action" do
    visit bulk_mail_actions_url
    click_on "Edit", match: :first

    fill_in "Action", with: @bulk_mail_action.action
    fill_in "Bulk mail", with: @bulk_mail_action.bulk_mail_id
    fill_in "Comment", with: @bulk_mail_action.comment
    fill_in "User", with: @bulk_mail_action.user_id
    click_on "Update Bulk mail action"

    assert_text "Bulk mail action was successfully updated"
    click_on "Back"
  end

  test "destroying a Bulk mail action" do
    visit bulk_mail_actions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bulk mail action was successfully destroyed"
  end
end
