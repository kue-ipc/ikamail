# frozen_string_literal: true

class BulkMailActionsController < ApplicationController
  before_action :set_bulk_mail_action, only: [:show, :edit, :update, :destroy]

  # GET /bulk_mail_actions
  # GET /bulk_mail_actions.json
  def index
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    authorize @bulk_mail, :readable?
    @bulk_mail_actions = @bulk_mail.bulk_mail_actions
  end

  # POST /bulk_mail_actions
  # POST /bulk_mail_actions.json
  def create
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    @bulk_mail_action = BulkMailAction.new(bulk_mail_action_params)
    @bulk_mail_action.bulk_mail = @bulk_mail
    @bulk_mail_action.user = current_user

    case @bulk_mail_action.action
    when 'apply'
      act_apply
    when 'withdraw'
      act_withdraw
    when 'approve'
      act_approve
    when 'reject'
      act_reject
    when 'cancel'
      act_cancel
    when 'deliver'
      act_deliver
    when 'discard'
      act_discard
    else
      @bulk_mail_action.errors.add(:actino, :invalid, message: 'は不正なアクションです。')
    end


    respond_to do |format|
      if @bulk_mail_action.errors.empty? && @bulk_mail_action.save
        format.html { redirect_to @bulk_mail }
        format.json { render :show, status: :created, location: @bulk_mail_action }
      else
        format.html { redirect_to @bulk_mail,
                                  alert: @bulk_mail_action.errors.full_messages }
        format.json { render json: @bulk_mail_action.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail_action
      @bulk_mail_action = BulkMailAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_action_params
      params.require(:bulk_mail_action).permit(:action, :comment)
    end

    def act_apply
      authorize @bulk_mail, :apply?
      @bulk_mail.update_columns(status: 'pending')
      NotificationMailer.with(
        user: @bulk_mail.bulk_mail_template.user,
        bulk_mail: @bulk_mail,
        comment: @bulk_mail_action.comment
      ).apply.deliver_later
      flash.notice = 'メールを申請し、管理者に通知しました。メールは承認後に配信されます。保留中の状態では変更や削除はできません。変更が必要な場合は、「取り下げ」を行い、下書きに戻してください。'
    end

    def act_withdraw
      authorize @bulk_mail, :withdraw?
      @bulk_mail.update_columns(status: 'draft')
    end

    def act_approve
      authorize @bulk_mail, :approve?
      @bulk_mail.update_columns(status: 'waiting')
      # タイミングによって配送処理
      case @bulk_mail.delivery_timing
      when 'immediate'
        BulkMailer.with(bulk_mail: @bulk_mail).all.deliver_later
      when 'reserved'
        #
      when 'manual'
        # 何もしない。
      else
        flash.alert = '不明な配送タイミングです。'
      end
    end

    def act_reject
      authorize @bulk_mail, :reject?
      @bulk_mail.update_columns(status: 'draft')
    end

end
