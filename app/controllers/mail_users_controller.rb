class MailUsersController < ApplicationController
  before_action :set_mail_user, only: [:show, :edit, :update, :destroy]

  # GET /mail_users
  # GET /mail_users.json
  def index
    @mail_users = MailUser.all
  end

  # GET /mail_users/1
  # GET /mail_users/1.json
  def show
  end

  # GET /mail_users/new
  def new
    @mail_user = MailUser.new
  end

  # GET /mail_users/1/edit
  def edit
  end

  # POST /mail_users
  # POST /mail_users.json
  def create
    @mail_user = MailUser.new(mail_user_params)

    respond_to do |format|
      if @mail_user.save
        format.html { redirect_to @mail_user, notice: 'Mail user was successfully created.' }
        format.json { render :show, status: :created, location: @mail_user }
      else
        format.html { render :new }
        format.json { render json: @mail_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mail_users/1
  # PATCH/PUT /mail_users/1.json
  def update
    respond_to do |format|
      if @mail_user.update(mail_user_params)
        format.html { redirect_to @mail_user, notice: 'Mail user was successfully updated.' }
        format.json { render :show, status: :ok, location: @mail_user }
      else
        format.html { render :edit }
        format.json { render json: @mail_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_users/1
  # DELETE /mail_users/1.json
  def destroy
    @mail_user.destroy
    respond_to do |format|
      format.html { redirect_to mail_users_url, notice: 'Mail user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_user
      @mail_user = MailUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_user_params
      params.fetch(:mail_user, {})
    end
end
