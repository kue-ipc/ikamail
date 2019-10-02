require "application_system_test_case"

class MailTemplatesTest < ApplicationSystemTestCase
  setup do
    @mail_template = mail_templates(:one)
  end

  test "visiting the index" do
    visit mail_templates_url
    assert_selector "h1", text: "Mail Templates"
  end

  test "creating a Mail template" do
    visit mail_templates_url
    click_on "New Mail Template"

    fill_in "Body footer", with: @mail_template.body_footer
    fill_in "Body header", with: @mail_template.body_header
    fill_in "Count", with: @mail_template.count
    fill_in "Description", with: @mail_template.description
    fill_in "From mail address", with: @mail_template.from_mail_address
    fill_in "From name", with: @mail_template.from_name
    fill_in "Name", with: @mail_template.name
    fill_in "Recipient list", with: @mail_template.recipient_list
    fill_in "Reservation time", with: @mail_template.reservation_time
    fill_in "Subject post", with: @mail_template.subject_post
    fill_in "Subject pre", with: @mail_template.subject_pre
    click_on "Create Mail template"

    assert_text "Mail template was successfully created"
    click_on "Back"
  end

  test "updating a Mail template" do
    visit mail_templates_url
    click_on "Edit", match: :first

    fill_in "Body footer", with: @mail_template.body_footer
    fill_in "Body header", with: @mail_template.body_header
    fill_in "Count", with: @mail_template.count
    fill_in "Description", with: @mail_template.description
    fill_in "From mail address", with: @mail_template.from_mail_address
    fill_in "From name", with: @mail_template.from_name
    fill_in "Name", with: @mail_template.name
    fill_in "Recipient list", with: @mail_template.recipient_list
    fill_in "Reservation time", with: @mail_template.reservation_time
    fill_in "Subject post", with: @mail_template.subject_post
    fill_in "Subject pre", with: @mail_template.subject_pre
    click_on "Update Mail template"

    assert_text "Mail template was successfully updated"
    click_on "Back"
  end

  test "destroying a Mail template" do
    visit mail_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mail template was successfully destroyed"
  end
end
