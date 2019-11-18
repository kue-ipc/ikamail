# frozen_string_literal: true

class BulkMailsController < ApplicationController
  before_action :set_bulk_mail, only: [:show, :edit, :update, :destroy,
                                       :apply, :withdraw, :approve, :reject, :cancel, :reserve, :deliver,
                                       :redeliver, :discard]
  before_action :set_comment, only: [:create, :update, :destroy,
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
  def show; end

  # GET /bulk_mails/new
  def new
    @bulk_mail = BulkMail.new
    @comment = nil
  end

  # GET /bulk_mails/1/edit
  def edit
    @comment = nil
  end

  # POST /bulk_mails
  # POST /bulk_mails.json
  def create
    @bulk_mail = BulkMail.new(bulk_mail_params)
    @bulk_mail.status = 'draft'
    @bulk_mail.user = current_user
    respond_to do |format|
      if @bulk_mail.save
        ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                         action: 'create', comment: @comment)
        format.html { redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :create) }
        format.json { render :show, status: :created, location: @bulk_mail }
      else
        format.html { render :new }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_mails/1
  # PATCH/PUT /bulk_mails/1.json
  def update
    respond_to do |format|
      if @bulk_mail.update(bulk_mail_params)
        ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                         action: 'update', comment: @comment)
        format.html { redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :update) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { render :edit }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_mails/1
  # DELETE /bulk_mails/1.json
  def destroy
    @bulk_mail.destroy
    # 削除時にログも削除されるため、ログには何も書かない。
    respond_to do |format|
      format.html { redirect_to bulk_mails_url, notice: t_success_action(BulkMail, :destroy) }
      format.json { head :no_content }
    end
  end

  # Acions
  # PUT /bulk_mails/1/{action}

  def apply
    respond_to do |format|
      if @bulk_mail.update(status: 'pending')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'apply', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        if current_user != @bulk_mail.template.user
          unless NotificationMailer.with(user: @bulk_mail.template.user, bulk_mail: @bulk_mail,
                                         comment: @comment).mail_apply.deliver_later
            flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
          end
        end
        format.html { redirect_to @bulk_mail, notice: t(:apply, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def withdraw
    respond_to do |format|
      if @bulk_mail.update(status: 'dfraft')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'withdraw', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        format.html { redirect_to @bulk_mail, notice: t(:withdraw, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    respond_to do |format|
      if @bulk_mail.update(status: 'ready')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'approve', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        if current_user != @bulk_mail.user
          unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                         comment: @comment).mail_approve.deliver_later
            flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
          end
        end
        # TODO: 準備完了即時配信のジョブなどのジョブ
        format.html { redirect_to @bulk_mail, notice: t(:approve, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @bulk_mail.update(status: 'draft')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'reject', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        if current_user != @bulk_mail.user
          unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                         comment: @comment).mail_apply.deliver_later
            flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
          end
        end
        format.html { redirect_to @bulk_mail, notice: t(:reject, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @bulk_mail.update(status: 'pending')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'cancel', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        if current_user != @bulk_mail.user
          unless NotificationMailer.with(user: @bulk_mail.user, bulk_mail: @bulk_mail,
                                         comment: @comment).mail_apply.deliver_later
            flash.alert = flash.alert.to_s + t(:cannot_deliver_notification, scope: :messages)
          end
        end
        format.html { redirect_to @bulk_mail, notice: t(:cancel, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def reserve
    respond_to do |format|
      if @bulk_mail.update(status: 'reserved')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'reserve', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        format.html { redirect_to @bulk_mail, notice: t(:reserve, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def deliver
    respond_to do |format|
      if @bulk_mail.update(status: 'waiting')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'deliver', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        format.html { redirect_to @bulk_mail, notice: t(:deliver, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def redeliver
    respond_to do |format|
      if @bulk_mail.update(status: 'waiting')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'redeliver', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        format.html { redirect_to @bulk_mail, notice: t(:redeliver, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  def discard
    respond_to do |format|
      if @bulk_mail.update(status: 'waste')
        unless ActionLog.create(bulk_mail: @bulk_mail, user: current_user,
                                action: 'discard', comment: @comment)
          flash.alert = flash.alert.to_s + t(:cannot_log_action, scope: :messages)
        end
        format.html { redirect_to @bulk_mail, notice: t(:discard, scoep: [:mail, :done_messages]) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, :apply) }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail
      @bulk_mail = BulkMail.find(params[:id])
      authorize @bulk_mail
    end

    def set_comment
      @comment = params[:comment]
    end

    def authorize_bulk_mail
      authorize BulkMail
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_params
      params.require(:bulk_mail).permit(:template_id, :delivery_timing, :subject, :body)
    end
end
