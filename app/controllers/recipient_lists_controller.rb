class RecipientListsController < ApplicationController
  before_action :set_recipient_list, only: [:show, :edit, :update, :destroy]
  before_action :authrize_recipient_list, only: [:index, :new, :create]
  after_action :verify_authorized

  # GET /recipient_lists
  # GET /recipient_lists.json
  def index
    @recipient_lists = RecipientList.all
  end

  # GET /recipient_lists/1
  # GET /recipient_lists/1.json
  def show
  end

  # GET /recipient_lists/new
  def new
    @recipient_list = RecipientList.new
  end

  # GET /recipient_lists/1/edit
  def edit
  end

  # POST /recipient_lists
  # POST /recipient_lists.json
  def create
    @recipient_list = RecipientList.new(recipient_list_params)

    respond_to do |format|
      if @recipient_list.save
        format.html { redirect_to @recipient_list, notice: 'Recipient list was successfully created.' }
        format.json { render :show, status: :created, location: @recipient_list }
      else
        format.html { render :new }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipient_lists/1
  # PATCH/PUT /recipient_lists/1.json
  def update
    respond_to do |format|
      if @recipient_list.update(recipient_list_params)
        format.html { redirect_to @recipient_list, notice: 'Recipient list was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        format.html { render :edit }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_lists/1
  # DELETE /recipient_lists/1.json
  def destroy
    respond_to do |format|
      if @recipient_list.destroy
        format.html { redirect_to recipient_lists_url, notice: 'Recipient list was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :show }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient_list
      @recipient_list = RecipientList.find(params[:id])
      authorize @recipient_list
    end

    def authrize_recipient_list
      authorize RecipientList
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipient_list_params
      permitted_params = params.require(:recipient_list)
        .permit(:name, :description,
                :included_mail_user_name_list,
                :excluded_mail_user_name_list,
                mail_group_ids: [])

      if permitted_params[:included_mail_user_name_list].present?
        permitted_params[:included_mail_users] = MailUser.where(
          name: permitted_params[:included_mail_user_name_list].split(','))
      end
      permitted_params.delete(:included_mail_user_name_list)

      if permitted_params[:excluded_mail_user_name_list].present?
        permitted_params[:excluded_mail_users] = MailUser.where(
          name: permitted_params[:excluded_mail_user_name_list].split(','))
      end
      permitted_params.delete(:excluded_mail_user_name_list)



      permitted_params
    end
end
