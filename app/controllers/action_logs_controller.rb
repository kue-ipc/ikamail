# frozen_string_literal: true

class ActionLogsController < ApplicationController
  before_action :set_action_log, only: [:show, :edit, :update, :destroy]

  # GET /action_logs
  # GET /action_logs.json
  def index
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    authorize @bulk_mail, :readable?
    @action_logs = @bulk_mail.action_logs
  end

  # POST /action_logs
  # POST /action_logs.json
  def create
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    @action_log = ActionLog.new(action_log_params)
    @action_log.bulk_mail = @bulk_mail
    @action_log.user = current_user

    case @action_log.action
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
      @action_log.errors.add(:actino, :invalid, message: 'は不正なアクションです。')
    end


    respond_to do |format|
      if @action_log.errors.empty? && @action_log.save
        format.html { redirect_to @bulk_mail }
        format.json { render :show, status: :created, location: @action_log }
      else
        format.html { redirect_to @bulk_mail,
                                  alert: @action_log.errors.full_messages }
        format.json { render json: @action_log.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_action_log
      @action_log = ActionLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def action_log_params
      params.require(:action_log).permit(:action, :comment)
    end

    def act_apply
      authorize @bulk_mail, :apply?
      @bulk_mail.update_columns(status: 'pending')
      NotificationMailer.with(
        user: @bulk_mail.template.user,
        bulk_mail: @bulk_mail,
        comment: @action_log.comment
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
