class BulkMailsController < ApplicationController
  before_action :set_bulk_mail, only: [:show, :edit, :update, :destroy]

  # GET /bulk_mails
  # GET /bulk_mails.json
  def index
    @bulk_mails = BulkMail.all
  end

  # GET /bulk_mails/1
  # GET /bulk_mails/1.json
  def show
  end

  # GET /bulk_mails/new
  def new
    @bulk_mail = BulkMail.new
  end

  # GET /bulk_mails/1/edit
  def edit
  end

  # POST /bulk_mails
  # POST /bulk_mails.json
  def create
    @bulk_mail = BulkMail.new(bulk_mail_params)

    respond_to do |format|
      if @bulk_mail.save
        format.html { redirect_to @bulk_mail, notice: 'Bulk mail was successfully created.' }
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
        format.html { redirect_to @bulk_mail, notice: 'Bulk mail was successfully updated.' }
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
    respond_to do |format|
      format.html { redirect_to bulk_mails_url, notice: 'Bulk mail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail
      @bulk_mail = BulkMail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_params
      params.require(:bulk_mail).permit(:mail_template_id, :subject, :body, :user_id, :delivery_datetime, :number, :mail_status_id)
    end
end
