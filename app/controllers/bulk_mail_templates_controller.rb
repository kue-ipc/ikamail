class BulkMailTemplatesController < ApplicationController
  before_action :set_bulk_mail_template, only: [:show, :edit, :update, :destroy]
  before_action :authorize_bulk_mail_template, only: [:index, :new, :create]


  # GET /bulk_mail_templates
  # GET /bulk_mail_templates.json
  def index
    @bulk_mail_templates = policy_scope(BulkMailTemplate)
  end

  # GET /bulk_mail_templates/1
  # GET /bulk_mail_templates/1.json
  def show
  end

  # GET /bulk_mail_templates/new
  def new
    @bulk_mail_template = BulkMailTemplate.new
  end

  # GET /bulk_mail_templates/1/edit
  def edit
  end

  # POST /bulk_mail_templates
  # POST /bulk_mail_templates.json
  def create
    @bulk_mail_template = BulkMailTemplate.new(bulk_mail_template_params)
    @bulk_mail_template.user = current_user

    respond_to do |format|
      if @bulk_mail_template.save
        format.html { redirect_to @bulk_mail_template, notice: 'Bulk mail template was successfully created.' }
        format.json { render :show, status: :created, location: @bulk_mail_template }
      else
        format.html { render :new }
        format.json { render json: @bulk_mail_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_mail_templates/1
  # PATCH/PUT /bulk_mail_templates/1.json
  def update
    respond_to do |format|
      if @bulk_mail_template.update(bulk_mail_template_params)
        format.html { redirect_to @bulk_mail_template, notice: 'Bulk mail template was successfully updated.' }
        format.json { render :show, status: :ok, location: @bulk_mail_template }
      else
        format.html { render :edit }
        format.json { render json: @bulk_mail_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_mail_templates/1
  # DELETE /bulk_mail_templates/1.json
  def destroy
    @bulk_mail_template.destroy
    respond_to do |format|
      format.html { redirect_to bulk_mail_templates_url, notice: 'Bulk mail template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail_template
      @bulk_mail_template = BulkMailTemplate.find(params[:id])
      authorize @bulk_mail_template
    end

    def authorize_bulk_mail_template
      authorize BulkMailTemplate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_template_params
      params.require(:bulk_mail_template).permit(
        :name, :recipient_list_id,
        :from_name, :from_mail_address,
        :subject_prefix, :subject_postfix,
        :body_header, :body_footer,
        :count,
        :reserved_time,
        :description)
    end
end
