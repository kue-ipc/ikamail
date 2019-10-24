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
        format.html { redirect_to @bulk_mail,
                                  notice: "#{t(@bulk_mail_action.action, scope: [:mail, :action])}しました" }
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
    end

    def act_withdraw
      if @bulk_mail.status != 'pending'
        @bulk_mail_action.errors.add(:bulk_mail, :not_allow, message: '承認待ちではないため、取り下げすることはできません。')
        return
      end
      @bulk_mail.update_columns(status: 'draft')
    end

    def act_approve
      unless policy(@bulk_mail).manageable?
        @bulk_mail_action.errors.add(:user, :not_allow, message: '承認する権限がありません。')
        return
      end

      if @bulk_mail.status != 'pending'
        @bulk_mail_action.errors.add(:bulk_mail, :not_allow, message: '承認待ちではないため、承認することはできません。')
        return
      end
      @bulk_mail.update_columns(status: 'waiting')
      # タイミングによって配送処理
      case @bulk_mail.delivery_timing
      when 'immediate'
      when 'reserved'
        #
      when 'manual'
        # 何もしない。
      else
        flash.alert = '不明な配送タイミングです。'
      end
    end

    def act_reject
      unless policy(@bulk_mail).manageable?
        @bulk_mail_action.errors.add(:user, :not_allow, message: '却下する権限がありません。')
        return
      end

      if @bulk_mail.status != 'pending'
        @bulk_mail_action.errors.add(:bulk_mail, :not_allow, message: '承認待ちではないため、却下することはできません。')
        return
      end
      @bulk_mail.update_columns(status: 'draft')
    end

end
