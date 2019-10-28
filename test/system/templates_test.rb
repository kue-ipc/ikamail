require "application_system_test_case"

class TemplatesTest < ApplicationSystemTestCase
  setup do
    @template = templates(:one)
  end

  test "visiting the index" do
    visit templates_url
    assert_selector "h1", text: "Bulk Mail Templates"
  end

  test "creating a Bulk mail template" do
    visit templates_url
    click_on "New Bulk Mail Template"

    fill_in "Body footer", with: @template.body_footer
    fill_in "Body header", with: @template.body_header
    fill_in "Count", with: @template.count
    fill_in "Description", with: @template.description
    fill_in "From mail address", with: @template.from_mail_address
    fill_in "From name", with: @template.from_name
    fill_in "Name", with: @template.name
    fill_in "Recipient list", with: @template.recipient_list
    fill_in "Reservation time", with: @template.reserved_time
    fill_in "Subject post", with: @template.subject_postfix
    fill_in "Subject pre", with: @template.subject_prefix
    click_on "Create Bulk mail template"

    assert_text "Bulk mail template was successfully created"
    click_on "Back"
  end

  test "updating a Bulk mail template" do
    visit templates_url
    click_on "Edit", match: :first

    fill_in "Body footer", with: @template.body_footer
    fill_in "Body header", with: @template.body_header
    fill_in "Count", with: @template.count
    fill_in "Description", with: @template.description
    fill_in "From mail address", with: @template.from_mail_address
    fill_in "From name", with: @template.from_name
    fill_in "Name", with: @template.name
    fill_in "Recipient list", with: @template.recipient_list
    fill_in "Reservation time", with: @template.reserved_time
    fill_in "Subject post", with: @template.subject_postfix
    fill_in "Subject pre", with: @template.subject_prefix
    click_on "Update Bulk mail template"

    assert_text "Bulk mail template was successfully updated"
    click_on "Back"
  end

  test "destroying a Bulk mail template" do
    visit templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bulk mail template was successfully destroyed"
  end
end
