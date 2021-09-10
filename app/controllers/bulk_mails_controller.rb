class BulkMailsController < ApplicationController
  before_action :set_action_info, only: %i[create update
                                           apply withdraw approve reject cancel reserve deliver discard]
  before_action :set_bulk_mail, only: %i[show edit update destroy
                                         apply withdraw approve reject cancel reserve deliver discard]
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
    @bulk_mail.wrap_col = 76
    @bulk_mail.wrap_rule = 'jisx4051'
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
      redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :create) +
                                      t(:create, scope: [:mail, :done_messages])
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
      redirect_to @bulk_mail, notice: t_success_action(@bulk_mail, :update) +
                                      t(:update, scope: [:mail, :done_messages])
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
      record_action_log
      send_notification_mail(to: @bulk_mail.template.user)
      flash.notice = t(:apply, scope: [:mail, :done_messages])
      timing_message = t(@bulk_mail.delivery_timing, scope: [:mail, :done_timing_messages, :apply])
      flash.notice = [*flash.notice, timing_message] if timing_message.present?
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :apply)]
    end
    redirect_to @bulk_mail
  end

  def withdraw
    if @bulk_mail.update(status: 'draft')
      record_action_log
      flash.notice = t(:withdraw, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :withdraw)]
    end
    redirect_to @bulk_mail
  end

  def approve
    if @bulk_mail.update(status: 'ready')
      record_action_log
      send_notification_mail(to: @bulk_mail.user)
      flash.notice = [*flash.notice, t(:approve, scope: [:mail, :done_messages])]
      if @bulk_mail.delivery_timing_immediate? && @bulk_mail.update(status: 'waiting')
        ActionLog.create(bulk_mail: @bulk_mail, action: 'deliver', comment: 'auto')
        BulkMailer.with(bulk_mail: @bulk_mail).all.deliver_later
        flash.notice = [*flash.notice, t(:deliver, scope: [:mail, :done_messages])]
      end

      if @bulk_mail.delivery_timing_reserved? &&
         @bulk_mail.update(status: 'reserved', reserved_at: @bulk_mail.template.next_reserved_datetime)
        ActionLog.create(bulk_mail: @bulk_mail, action: 'reserve', comment: 'auto')
        ReservedDeliveryJob.set(wait_until: @bulk_mail.reserved_at).perform_later(@bulk_mail.id)
        flash.notice = [*flash.notice, t(:reserve, scope: [:mail, :done_messages])]
      end
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :approve)]
    end

    redirect_to @bulk_mail
  end

  def reject
    if @bulk_mail.update(status: 'draft')
      record_action_log
      send_notification_mail(to: @bulk_mail.user)
      flash.notice = t(:reject, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :reject)]
    end
    redirect_to @bulk_mail
  end

  def cancel
    if @bulk_mail.update(status: 'pending')
      record_action_log
      send_notification_mail(to: @bulk_mail.user)
      flash.notice = t(:cancel, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :cancel)]
    end
    redirect_to @bulk_mail
  end

  def reserve
    if @bulk_mail.update(status: 'reserved', reserved_at: @action_info.datetime)
      record_action_log
      ReservedDeliveryJob.set(wait_until: @bulk_mail.reserved_at).perform_later(@bulk_mail.id)
      flash.notice = t(:reserve, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :reserve)]
    end
    redirect_to @bulk_mail
  end

  def deliver
    if @bulk_mail.update(status: 'waiting')
      record_action_log
      BulkMailer.with(bulk_mail: @bulk_mail).all.deliver_later
      flash.notice = t(:deliver, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :deliver)]
    end
    redirect_to @bulk_mail
  end

  def discard
    if @bulk_mail.update(status: 'waste')
      record_action_log
      flash.notice = t(:discard, scope: [:mail, :done_messages])
    else
      flash.alert = [*flash.alert, t_failure_action(@bulk_mail, :discard)]
    end
    redirect_to @bulk_mail
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_bulk_mail
    @bulk_mail = BulkMail.find(params[:id])
    if @action_info && @action_info.current_status != @bulk_mail.status
      authorize @bulk_mail, :show?
      redirect_to @bulk_mail, alert: t_failure_action(@bulk_mail, action_name)
      return
    end

    authorize @bulk_mail
  end

  private def set_action_info
    @action_info = ActionInfo.new(action_info_params)
  end

  private def authorize_bulk_mail
    authorize BulkMail
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private def bulk_mail_params
    params.require(:bulk_mail).permit(:template_id, :delivery_timing, :subject, :body, :wrap_col, :wrap_rule)
  end

  private def action_info_params
    params.require(:action_info).permit(:comment, :current_status, :datetime)
  end

  private def record_action_log(action: action_name, user: current_user)
    action_log = ActionLog.create(bulk_mail: @bulk_mail, user: user,
      action: action, comment: @action_info.comment)
    flash.alert = [*flash.alert, t(:failure_record_action_log, scope: :messages)] unless action_log
    action_log
  end

  private def send_notification_mail(action: action_name, to: current_user, skip_current_user: true)
    return if skip_current_user && current_user == to

    mailer = NotificationMailer.with(to: to, bulk_mail: @bulk_mail, comment: @action_info.comment)
      .send("mail_#{action}")
      .deliver_later
    flash.alert = [*flash.alert, t(:failure_send_notification_mail, scope: :messages)] unless mailer
    mailer
  end
end
