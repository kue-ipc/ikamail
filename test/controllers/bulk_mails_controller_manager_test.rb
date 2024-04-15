require "test_helper"

require_relative "bulk_mails_controller_test"

class BulkMailsControllerManagerTest < BulkMailsControllerTest
  # all tempalte is managed by user03
  setup do
    sign_in users(:user03)
  end

  test "should get index" do
    get bulk_mails_url
    assert_response :success
  end

  test "should get new" do
    get new_bulk_mail_url
    assert_response :success
  end

  test "should create bulk_mail" do
    assert_difference("BulkMail.count") do
      post bulk_mails_url, params: {
        bulk_mail: {
          mail_template_id: @bulk_mail.mail_template_id,
          subject: @bulk_mail.subject,
          body: @bulk_mail.body,
          delivery_timing: @bulk_mail.delivery_timing,
          action_info: @action_info_params,
        },
      }
    end

    assert_redirected_to bulk_mail_url(BulkMail.last)
  end

  test "should show bulk_mail" do
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should get edit" do
    get edit_bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should update bulk_mail" do
    patch bulk_mail_url(@bulk_mail), params: {
      bulk_mail: {
        mail_template_id: @bulk_mail.mail_template_id,
        subject: @bulk_mail.subject,
        body: @bulk_mail.body,
        action_info: @action_info_params,
      },
    }
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should destroy bulk_mail" do
    assert_difference("BulkMail.count", -1) do
      delete bulk_mail_url(@bulk_mail)
    end

    assert_redirected_to bulk_mails_url
  end

  ## draft ##

  test "should show DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should edit DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    get edit_bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should update DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
      mail_template_id: mail_templates(:users).id,
      action_info: @action_info_params,
    }}
    assert_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should destroy DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_difference("BulkMail.count", -1) do
      delete bulk_mail_url(@bulk_mail)
    end
    assert_redirected_to bulk_mails_url
  end

  test "should NOT apply DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should approve DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    put approve_bulk_mail_url(@bulk_mail),
      params: {bulk_mail: {action_info: @action_info_params}}
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should NOT reject DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard DRAFT" do
    @bulk_mail = bulk_mails(:draft)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
  end

  ## pending ##
  test "should show PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should edit PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    get edit_bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should update PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
      mail_template_id: mail_templates(:users).id,
      action_info: @action_info_params,
    }}
    assert_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should destroy PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_difference("BulkMail.count", -1) do
      delete bulk_mail_url(@bulk_mail)
    end
    assert_redirected_to bulk_mails_url
  end

  test "should NOT apply PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  test "should approve PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 1 do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject

    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should reject PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 1 do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】受付拒否"), mail.subject

    assert_equal "draft", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should NOT deliver PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard PENDING" do
    @bulk_mail = bulk_mails(:pending)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
  end

  ## ready ##
  test "should show READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
  end

  test "should deliver READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 2 do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal @bulk_mail.mail_template.recipient_list.applicable_mail_users.map(&:mail) |
      [@bulk_mail.mail_template.user.email, @bulk_mail.user.email], mail.bcc
    assert_equal u8tomjis("【全】テスト全ユーザーオール"), mail.subject

    # メールのチェックが終わった時点で配送は完了している。
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should reserve READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_enqueued_with(job: ReservedDeliveryJob) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
    assert_not_nil BulkMail.find(@bulk_mail.id).reservation_number
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should cancel READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 1 do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】配信中止"), mail.subject

    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should NOT discard READY" do
    @bulk_mail = bulk_mails(:ready)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
  end

  ## reserved ##
  test "should show RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  test "should cancel RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 1 do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】配信中止"), mail.subject

    assert_equal "pending", BulkMail.find(@bulk_mail.id).status
    assert_nil BulkMail.find(@bulk_mail.id).reserved_at
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should NOT discard RESERVED" do
    @bulk_mail = bulk_mails(:reserved)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
  end

  ## waiting ##
  test "should show WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard WAITING" do
    @bulk_mail = bulk_mails(:waiting)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waiting", BulkMail.find(@bulk_mail.id).status
  end

  ## delivering ##
  test "should show DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard DELIVERING" do
    @bulk_mail = bulk_mails(:delivering)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivering", BulkMail.find(@bulk_mail.id).status
  end

  ## delivered ##
  test "should show DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
  end

  ## failed ##
  test "should show FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should deliver FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 2 do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal @bulk_mail.mail_template.recipient_list.applicable_mail_users.map(&:mail) |
      [@bulk_mail.mail_template.user.email, @bulk_mail.user.email], mail.bcc
    assert_equal u8tomjis("【全】テスト全ユーザーオール"), mail.subject

    # メールのチェックが終わった時点で配送は完了している。
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should NOT reserve FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "failed", BulkMail.find(@bulk_mail.id).status
  end

  test "should discard FAILED" do
    @bulk_mail = bulk_mails(:failed)
    @action_info_params[:current_status] = @bulk_mail.status
    put discard_bulk_mail_url(@bulk_mail),
      params: {bulk_mail: {action_info: @action_info_params}}
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  ## error ##
  test "should show ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "error", BulkMail.find(@bulk_mail.id).status
  end

  test "should discard ERROR" do
    @bulk_mail = bulk_mails(:error)
    @action_info_params[:current_status] = @bulk_mail.status
    put discard_bulk_mail_url(@bulk_mail),
      params: {bulk_mail: {action_info: @action_info_params}}
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  ## waste ##
  test "should show WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  test "should NOT edit WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulk_mail_url(@bulk_mail)
    end
  end

  test "should NOT update WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
        mail_template_id: mail_templates(:users).id,
        action_info: @action_info_params,
      }}
    end
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
  end

  test "should NOT destroy WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_no_difference("BulkMail.count") do
      assert_raises(Pundit::NotAuthorizedError) do
        delete bulk_mail_url(@bulk_mail)
      end
    end
  end

  test "should NOT apply WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put apply_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT withdraw WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put withdraw_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT approve WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reject WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reject_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT deliver WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put deliver_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT reserve WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put reserve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT cancel WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put cancel_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  test "should NOT discard WASTE" do
    @bulk_mail = bulk_mails(:waste)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_raises(Pundit::NotAuthorizedError) do
      put discard_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
  end

  ## error no number ##
  test "should destroy ERROR NO NUMBER" do
    @bulk_mail = bulk_mails(:error_no_number)
    @action_info_params[:current_status] = @bulk_mail.status
    assert_difference("BulkMail.count", -1) do
      delete bulk_mail_url(@bulk_mail)
    end
    assert_redirected_to bulk_mails_url
  end

  test "should discard ERROR NO NUMBER" do
    @bulk_mail = bulk_mails(:error_no_number)
    @action_info_params[:current_status] = @bulk_mail.status
    put discard_bulk_mail_url(@bulk_mail),
      params: {bulk_mail: {action_info: @action_info_params}}
    assert_equal "waste", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  ## change status ##
  test "should show DRAFT to DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    get bulk_mail_url(@bulk_mail)
    assert_response :success
  end

  # test 'redirect show INSTEAD OF edit DRAFT to DELIVERED' do
  #   @bulk_mail = bulk_mails(:delivered)
  #   get edit_bulk_mail_url(@bulk_mail)
  #   assert_redirected_to bulk_mail_url(@bulk_mail)
  # end

  test "should NOT update DRAFT to DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    patch bulk_mail_url(@bulk_mail), params: {bulk_mail: {
      mail_template_id: mail_templates(:users).id,
      action_info: @action_info_params,
    }}
    assert_not_equal mail_templates(:users).id,
      BulkMail.find(@bulk_mail.id).mail_template_id
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  # test 'should NOT destroy DRAFT to DELIVERED' do
  #   @bulk_mail = bulk_mails(:delivered)
  #   assert_no_difference('BulkMail.count') do
  #     delete bulk_mail_url(@bulk_mail)
  #   end
  #   assert_redirected_to bulk_mail_url(@bulk_mail)
  # end

  test "should NOT apply DRAFT to DELIVERED" do
    @bulk_mail = bulk_mails(:delivered)
    put apply_bulk_mail_url(@bulk_mail),
      params: {bulk_mail: {action_info: @action_info_params}}
    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  ## timing ##

  test "should approve PENDING IMMEDIATE" do
    @bulk_mail = bulk_mails(:pending_immediate)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 3 do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries[-3]
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject

    mail = ActionMailer::Base.deliveries[-2]
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】配信完了"), mail.subject

    mail = ActionMailer::Base.deliveries[-1]
    assert_equal @bulk_mail.mail_template.recipient_list.applicable_mail_users.map(&:mail) |
      [@bulk_mail.mail_template.user.email, @bulk_mail.user.email], mail.bcc
    assert_equal u8tomjis("【全】テスト全ユーザーオール"), mail.subject

    assert_equal "delivered", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should approve PENDING RESERVED" do
    @bulk_mail = bulk_mails(:pending_reserved)
    @action_info_params[:current_status] = @bulk_mail.status

    # メールのテストを有効にするとJobのテストができなくなる。
    # assert_emails 1 do
    assert_enqueued_with(job: ReservedDeliveryJob) do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end
    # end

    # mail = ActionMailer::Base.deliveries.last
    # assert_equal [@bulk_mail.user.email], mail.to
    # assert_equal u8tomjis('【一括メールシステム通知】受付完了'), mail.subject

    assert_equal "reserved", BulkMail.find(@bulk_mail.id).status
    assert_not_nil BulkMail.find(@bulk_mail.id).reservation_number
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end

  test "should approve PENDING MANUAL" do
    @bulk_mail = bulk_mails(:pending_manual)
    @action_info_params[:current_status] = @bulk_mail.status

    assert_emails 1 do
      put approve_bulk_mail_url(@bulk_mail),
        params: {bulk_mail: {action_info: @action_info_params}}
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [@bulk_mail.user.email], mail.to
    assert_equal u8tomjis("【一括メールシステム通知】受付完了"), mail.subject

    assert_equal "ready", BulkMail.find(@bulk_mail.id).status
    assert_redirected_to bulk_mail_url(@bulk_mail)
  end
end
