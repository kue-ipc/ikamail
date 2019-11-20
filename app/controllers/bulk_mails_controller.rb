# frozen_string_literal: true

class BulkMailsController < ApplicationController
  before_action :set_bulk_mail, only: [:show, :edit, :update, :destroy,
                                       :apply, :withdraw, :approve, :reject, :cancel, :reserve, :deliver,
                                       :redeliver, :discard]
  before_action :set_action_info, only: [:create, :update,
                                         :apply, :withdraw, :approve, :reject, :cancel, :reserve, :deliver,
                                         :redeliver, :discard]
  before_action :authorize_bulk_mail, only: [:index, :new, :create]

  # GET /bulk_mails
  # GET /bulk_mails.json
  def index
    @bulk_mails = policy_scope(BulkMail).includes(:user, :template).order(updated_at: :desc).page(params[:page])
  end

  # GET /bulk_mails/1
  # GET /bulk_mails/1.json
  def show
    @action_info = ActionInfo.new(current_status: @bulk_mail.status, datetime: Time.zone.now.since(1.hour))
  end

  # GET /bulk_mails/new
  def new
    @bulk_mail = BulkMail.new
    @action_info = ActionInfo.new
  end

  # GET /bulk_mails/1/edit
  def edit
    @action_info = ActionInfo.new(current_status: @bulk_mail.status)
  end

  # POST /bulk_mails
  # POST /bulk_mails.json
  def create
    @bulk_mail = BulkMail.new(bulk_mail_params)
    @bulk_mail.status = 'draft'
    @bulk_mail.user = current_user
    if @bulk_mail.save
      record_action_log
      redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :create)
    else
      @action_info.current_status = nil
      render :new
    end
  end

  # PATCH/PUT /bulk_mails/1
  # PATCH/PUT /bulk_mails/1.json
  def update
    if @bulk_mail.update(bulk_mail_params)
      record_action_log
      redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :update)
    else
      render :edit
    end
  end

  # DELETE /bulk_mails/1
  # DELETE /bulk_mails/1.json
  def destroy
    @bulk_mail.destroy
    # 削除時にログも削除されるため、ログには何も書かない。
    redirect_to bulk_mails_url, notice: t_success_action(BulkMail, :destroy)
  end

  # Acions
  # PUT /bulk_mails/1/{action}

  def apply
    if @bulk_mail.update(status: 'pending')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'apply', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      if current_user != @bulk_mail.template.user
        unless NotificationMailer.with(user: @bulk_mail.template.user, bulk_mail: @bulk_mail,
                                       comment: @action_info.comment).mail_apply.deliver_later
          flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
        end
      end
      redirect_to @bulk_mail, notice: t(:apply, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def withdraw
    if @bulk_mail.update(status: 'draft')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'withdraw', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      redirect_to @bulk_mail, notice: t(:withdraw, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def approve
    if @bulk_mail.update(status: 'ready')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'approve', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      if current_user != @bulk_mail.user
        unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                       comment: @action_info.comment).mail_approve.deliver_later
          flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
        end
      end
      # TODO: 準備完了即時配信のジョブなどのジョブ
      redirect_to @bulk_mail, notice: t(:approve, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def reject
    if @bulk_mail.update(status: 'draft')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'reject', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      if current_user != @bulk_mail.user
        unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                       comment: @action_info.comment).mail_apply.deliver_later
          flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
        end
      end
      redirect_to @bulk_mail, notice: t(:reject, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def cancel
    if @bulk_mail.update(status: 'pending')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'cancel', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      if current_user != @bulk_mail.user
        unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                       comment: @action_info.comment).mail_apply.deliver_later
          flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
        end
      end
      redirect_to @bulk_mail, notice: t(:cancel, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def reserve
    if @bulk_mail.update(status: 'reserved', reserved_at: @action_info.datetime)
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'reserve', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      ReservedDeliveryJob.set(wait_until: @action_info.datetime).perform_later(@bulk_mail.id)
      redirect_to @bulk_mail, notice: t(:reserve, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def deliver
    if @bulk_mail.update(status: 'waiting')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'deliver', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      redirect_to @bulk_mail, notice: t(:deliver, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def redeliver
    if @bulk_mail.update(status: 'waiting')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'redeliver', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      redirect_to @bulk_mail, notice: t(:redeliver, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  def discard
    if @bulk_mail.update(status: 'waste')
      unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'discard', comment: @action_info.comment)
        flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
      end
      redirect_to @bulk_mail, notice: t(:discard, scope: [:mail, :done_messages])
    else
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail
      @bulk_mail = BulkMail.find(params[:id])
      authorize @bulk_mail
    end

    def set_action_info
      @action_info = ActionInfo.new(action_info_params)
    end

    def authorize_bulk_mail
      authorize BulkMail
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_params
      params.require(:bulk_mail).permit(:template_id, :delivery_timing, :subject, :body)
    end

    def action_info_params
      params.require(:action_info).permit(:comment, :current_status, :datetime)
    end

    def record_action_log(action: action_name, user: current_user)
      action_log =  ActionLog.create(bulk_mail: @bulk_mail, user: user,
                              action: action, comment: @action_info.comment)
      flash.alert = [*flash.alert, t(:failure_record_action_log, scope: :messages)] unless action_log
      action_log
    end

    def send_notification_mail(action: action_name, user: @bulk_mail.user, skip_current_user: true)
      return if skip_current_user && current_user == user

      mailer = NotificationMailer.with(user: user, bulk_mail: @bulk_mail,
                                       comment: @action_info.comment).send("mail_#{action}").deliver_later
      flash.alert = [*flash.alert, t(:failure_send_notification_mail, scope: :messages)] unless mailler
      mailer
    end
end
