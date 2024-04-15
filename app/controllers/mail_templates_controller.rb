class MailTemplatesController < ApplicationController
  before_action :set_mail_template,
    only: [ :show, :edit, :update, :destroy, :count ]
  before_action :authorize_mail_template, only: [ :index, :new, :create ]

  # GET /mail_templates
  # GET /mail_templates.json
  def index
    @mail_templates = policy_scope(MailTemplate).order(:name).page(params[:page])
  end

  # GET /mail_templates/1
  # GET /mail_templates/1.json
  def show
  end

  # GET /mail_templates/new
  def new
    @mail_template = MailTemplate.new
    @mail_template.reserved_time = "12:00"
  end

  # GET /mail_templates/1/edit
  def edit
  end

  # POST /mail_templates
  # POST /mail_templates.json
  def create
    @mail_template = MailTemplate.new(mail_template_params)
    @mail_template.user ||= current_user

    if @mail_template.save
      redirect_to @mail_template,
        notice: t_success_action(@mail_template, :create)
    else
      render :new
    end
  end

  # PATCH/PUT /mail_templates/1
  # PATCH/PUT /mail_templates/1.json
  def update
    if @mail_template.update(mail_template_params)
      redirect_to @mail_template,
        notice: t_success_action(@mail_template, :update)
    else
      render :edit
    end
  end

  # DELETE /mail_templates/1
  # DELETE /mail_templates/1.json
  def destroy
    if @mail_template.destroy
      redirect_to mail_templates_url,
        notice: t_success_action(@mail_template, :destroy)
    else
      redirect_to @mail_template, alert: [
        t_failure_action(@mail_template, :destroy),
        *@mail_template.errors.messages.fetch(:base, [])
      ]
    end
  end

  def count
    if @mail_template.update(count_params)
      redirect_to @mail_template,
        notice: t_success_action(@mail_template, :update)
    else
      render :edit
    end
  end

  private def set_mail_template
    @mail_template = policy_scope(MailTemplate).find(params[:id])
    authorize @mail_template
  end

  private def authorize_mail_template
    authorize MailTemplate
  end

  private def mail_template_params
    permitted = params.require(:mail_template).permit(
      :name, :recipient_list_id,
      :from_name, :from_mail_address,
      :subject_prefix, :subject_suffix,
      :body_header, :body_footer,
      :count, :reserved_time, :description, :enabled,
      user: :username)
    if current_user.admin?
      permitted[:user] = User.find_by(username: permitted[:user][:username])
    else
      permitted.extract!(:recipient_list_id, :user)
    end
    permitted
  end

  private def count_params
    params.permit(:count)
  end
end
