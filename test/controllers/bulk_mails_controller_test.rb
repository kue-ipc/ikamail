require "test_helper"
require "helpers/jis_helper"
require "helpers/mail_helper"

class BulkMailsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include JisHelper
  include MailHelper

  setup do
    @bulk_mail = bulk_mails(:mail)
    @action_info_params = {
      comment: "コメント",
      current_status: @bulk_mail.status,
      datetime: Time.zone.now,
    }
  end

  class Anonymous < BulkMailsControllerTest
    test "redirect to login INSTEAD OF get index" do
      get bulk_mails_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF get new" do
      get new_bulk_mail_url
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF create bulk_mail" do
      assert_no_difference("BulkMail.count") do
        post bulk_mails_url, params: {
          bulk_mail: {
            mail_template_id: @bulk_mail.mail_template_id,
            subject: @bulk_mail.subject,
            body: @bulk_mail.body,
            delivery_timing: @bulk_mail.delivery_timing,
          },
          action_info: @action_info_params,
        }
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF show bulk_mail" do
      get bulk_mail_url(@bulk_mail)
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF get edit" do
      get edit_bulk_mail_url(@bulk_mail)
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF update bulk_mail" do
      patch bulk_mail_url(@bulk_mail), params: {
        bulk_mail: {
          mail_template_id: @bulk_mail.mail_template_id,
          subject: @bulk_mail.subject,
          body: @bulk_mail.body,
        },
        action_info: @action_info_params,
      }
      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF destroy bulk_mail" do
      assert_no_difference("BulkMail.count") do
        delete bulk_mail_url(@bulk_mail)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login INSTEAD OF apply bulk_mail" do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
      assert_equal "draft", BulkMail.find(@bulk_mail.id).status
      assert_redirected_to new_user_session_path
    end
  end
end
