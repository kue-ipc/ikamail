require 'test_helper'

class BulkMailsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @bulk_mail = bulk_mails(:mail)
    @action_info_params = {
      comment: 'コメント',
      current_status: @bulk_mail.status,
      datetime: Time.zone.now,
    }
  end

  # class SignInUser < BulkMailsControllerTest
  #   # bulk_mails(:mail) is  own
  #   setup do
  #     sign_in users(:user01)
  #   end
  #
  #   test 'should get index' do
  #     get bulk_mails_url
  #     assert_response :success
  #   end
  #
  #   test 'should get new' do
  #     get new_bulk_mail_url
  #     assert_response :success
  #   end
  #
  #   test 'should create bulk_mail' do
  #     assert_difference('BulkMail.count') do
  #       post bulk_mails_url, params: {
  #         bulk_mail: {
  #           mail_template_id: @bulk_mail.mail_template_id,
  #           subject: @bulk_mail.subject,
  #           body: @bulk_mail.body,
  #           delivery_timing: @bulk_mail.delivery_timing,
  #         },
  #       action_info: @action_info_params,
  #     }
  #     end
  #
  #     assert_redirected_to bulk_mail_url(BulkMail.last)
  #   end
  #
  #   test 'should show bulk_mail' do
  #     get bulk_mail_url(@bulk_mail)
  #     assert_response :success
  #   end
  #
  #   test 'should get edit' do
  #     get edit_bulk_mail_url(@bulk_mail)
  #     assert_response :success
  #   end
  #
  #   test 'should update bulk_mail' do
  #     patch bulk_mail_url(@bulk_mail), params: {
  #       bulk_mail: {
  #         mail_template_id: @bulk_mail.mail_template_id,
  #         subject: @bulk_mail.subject,
  #         body: @bulk_mail.body,
  #       },
  #       action_info: @action_info_params,
  #     }
  #     assert_redirected_to bulk_mail_url(@bulk_mail)
  #   end
  #
  #   test 'should destroy bulk_mail' do
  #     assert_difference('BulkMail.count', -1) do
  #       delete bulk_mail_url(@bulk_mail)
  #     end
  #
  #     assert_redirected_to bulk_mails_url
  #   end
  # end
  #
  # class SignInOtherUser < BulkMailsControllerTest
  #   setup do
  #     sign_in users(:user02)
  #   end
  #
  #   test 'should NOT show bulk_mail' do
  #     assert_raises(Pundit::NotAuthorizedError) do
  #       get bulk_mail_url(@bulk_mail)
  #     end
  #   end
  #
  #   test 'should NOT get edit' do
  #     assert_raises(Pundit::NotAuthorizedError) do
  #       get edit_bulk_mail_url(@bulk_mail)
  #     end
  #   end
  #
  #   test 'should NOT update bulk_mail' do
  #     assert_raises(Pundit::NotAuthorizedError) do
  #       patch bulk_mail_url(@bulk_mail), params: {
  #         bulk_mail: {
  #           mail_template_id: @bulk_mail.mail_template_id,
  #           subject: @bulk_mail.subject,
  #           body: @bulk_mail.body,
  #         },
  #         action_info: @action_info_params,
  #       }
  #     end
  #   end
  #
  #   test 'should NOT destroy bulk_mail' do
  #     assert_raises(Pundit::NotAuthorizedError) do
  #       delete bulk_mail_url(@bulk_mail)
  #     end
  #   end
  # end
  #
  # class SignInManager < BulkMailsControllerTest
  #   # all tempalte is managed
  #   setup do
  #     sign_in users(:user03)
  #   end
  #
  #   test 'should show bulk_mail' do
  #     get bulk_mail_url(@bulk_mail)
  #     assert_response :success
  #   end
  #
  #   test 'should get edit' do
  #     get edit_bulk_mail_url(@bulk_mail)
  #     assert_response :success
  #   end
  #
  #   test 'should update bulk_mail' do
  #     patch bulk_mail_url(@bulk_mail), params: {
  #       bulk_mail: {
  #         mail_template_id: @bulk_mail.mail_template_id,
  #         subject: @bulk_mail.subject,
  #         body: @bulk_mail.body,
  #       },
  #       action_info: @action_info_params,
  #     }
  #     assert_redirected_to bulk_mail_url(@bulk_mail)
  #   end
  #
  #   # 削除も可能にする？？？？
  #   test 'should destroy bulk_mail' do
  #     assert_difference('BulkMail.count', -1) do
  #       delete bulk_mail_url(@bulk_mail)
  #     end
  #
  #     assert_redirected_to bulk_mails_url
  #   end
  # end

  class Anonymous < BulkMailsControllerTest
    test 'redirect to login INSTEAD OF get index' do
      get bulk_mails_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get new' do
      get new_bulk_mail_url
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF create bulk_mail' do
      assert_no_difference('BulkMail.count') do
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

    test 'redirect to login INSTEAD OF show bulk_mail' do
      get bulk_mail_url(@bulk_mail)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF get edit' do
      get edit_bulk_mail_url(@bulk_mail)
      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF update bulk_mail' do
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

    test 'redirect to login INSTEAD OF destroy bulk_mail' do
      assert_no_difference('BulkMail.count') do
        delete bulk_mail_url(@bulk_mail)
      end

      assert_redirected_to new_user_session_path
    end

    test 'redirect to login INSTEAD OF apply bulk_mail' do
      put apply_bulk_mail_url(@bulk_mail), params: {action_info: @action_info_params}
      assert_equal 'draft', BulkMail.find(@bulk_mail.id).status
      assert_redirected_to new_user_session_path
    end
  end
end
