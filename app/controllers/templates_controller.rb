# frozen_string_literal: true

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
    @template.user = current_user

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: t_success_action(@template, :create) }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: t_success_action(@template, :update) }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: t_success_action(@template, :destroy) }
      format.json { head :no_content }
    end
  end

  def count
    respond_to do |format|
      if @template.update(count_params)
        format.html { redirect_to @template, notice: t_success_action(@template, :update) }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
      authorize @template
    end

    def authorize_template
      authorize Template
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      permitted = params.require(:template).permit(
        :name, :recipient_list_id,
        :from_name, :from_mail_address,
        :subject_prefix, :subject_suffix,
        :body_header, :body_footer,
        :reserved_time,
        :description,
        :enabled,
        user: :username)
      permitted[:user] = User.find_by(username: permitted[:user][:username])
      permitted
    end

    def count_params
      params.permit(:count)
    end
end
