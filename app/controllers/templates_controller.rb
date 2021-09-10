class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy, :count]
  before_action :authorize_template, only: [:index, :new, :create]

  # GET /templates
  # GET /templates.json
  def index
    @templates = policy_scope(Template).order(:name).page(params[:page])
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    @template.reserved_time = '12:00'
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)
    @template.user ||= current_user

    if @template.save
      redirect_to @template, notice: t_success_action(@template, :create)
    else
      render :new
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    if @template.update(template_params)
      redirect_to @template, notice: t_success_action(@template, :update)
    else
      render :edit
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    redirect_to templates_url, notice: t_success_action(@template, :destroy)
  end

  def count
    if @template.update(count_params)
      redirect_to @template, notice: t_success_action(@template, :update)
    else
      render :edit
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_template
    @template = Template.find(params[:id])
    authorize @template
  end

  private def authorize_template
    authorize Template
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private def template_params
    permitted = params.require(:template).permit(
      :name, :recipient_list_id,
      :from_name, :from_mail_address,
      :subject_prefix, :subject_suffix,
      :body_header, :body_footer,
      :count, :reserved_time, :description, :enabled,
      user: :username,
    )
    permitted[:user] = if current_user.admin?
        User.find_by(username: permitted[:user][:username])
      else
        current_user
      end
    permitted
  end

  private def count_params
    params.permit(:count)
  end
end
