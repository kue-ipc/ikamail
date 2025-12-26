require "test_helper"
require "helpers/policy_helper"

class BulkMailPolicyTest < ActiveSupport::TestCase
  include PolicyHelper

  setup do
    @admin = users(:admin)
    @user = users(:user01)
    @other_user = users(:user02)
    @template_user = users(:user03)

    # mail owner is @user, template owner is @template_user
    @draft_mail = bulk_mails(:draft) # draft status
    @pending_mail = bulk_mails(:pending) # pending status
    @ready_mail = bulk_mails(:ready) # ready status
    @reserved_mail = bulk_mails(:reserved) # reserved status
    @waiting_mail = bulk_mails(:waiting) # waiting status
    @delivering_mail = bulk_mails(:delivering) # delivering status
    @delivered_mail = bulk_mails(:delivered) # delivered status
    @waste_mail = bulk_mails(:waste) # waste status
    @failed_mail = bulk_mails(:failed) # failed status
    @error_mail = bulk_mails(:error) # error status
    @error_no_number_mail = bulk_mails(:error_no_number) # error status and no number
  end

  # TODO: ゲストとして nil の場合を書く

  test "index" do
    assert_permit @admin, :bulk_mail, :index
    assert_permit @user, :bulk_mail, :index
  end

  test "new and create" do
    assert_permit @admin, :bulk_mail, :new
    assert_permit @user, :bulk_mail, :new

    assert_permit @admin, :bulk_mail, :create
    assert_permit @user, :bulk_mail, :create
  end

  test "draft mail" do
    # admin
    assert_permit @admin, @draft_mail, :show
    assert_permit @admin, @draft_mail, :update
    assert_permit @admin, @draft_mail, :edit
    assert_permit @admin, @draft_mail, :destroy

    assert_not_permit @admin, @draft_mail, :apply
    assert_not_permit @admin, @draft_mail, :withdraw
    assert_permit @admin, @draft_mail, :approve
    assert_not_permit @admin, @draft_mail, :reject
    assert_not_permit @admin, @draft_mail, :cancel
    assert_not_permit @admin, @draft_mail, :reserve
    assert_not_permit @admin, @draft_mail, :deliver
    assert_not_permit @admin, @draft_mail, :discard

    # TODO: メソッド単位でまとめて作る予定。
  end

  # TODO: 実装
  # test "scope" do
  # end
end
