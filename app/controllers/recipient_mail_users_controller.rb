class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_attribute
  before_action :set_mail_user, only: [:show, :update, :destroy]

  # GET /recipient_mail_users
  # GET /recipient_mail_users.json
  def index
    @mail_users =
      if @attribute == :inclruded
        @recipient_list.included_mail_users
      elsif @attribute == :excluded
        @recipient_list.exludede_mail_users
      end
  end

  # GET /recipient_mail_users/1
  # GET /recipient_mail_users/1.json
  def show
  end

  # POST /recipient_mail_users
  # POST /recipient_mail_users.json
  def create
    @mail_user = MailUser.find_by(name_params)

    respond_to do |format|
      if @mail_user
        @recipient = Recipient.find_or_create_by(recipient_list: @recipient_list, mail_user: @mail_user)
        @recipient.update_column(@attribute, true)

        format.html { redirect_to @recipient_list, notice: '一覧にユーザーを追加しました。' }
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        format.html { redirect_to @recipient_list, alert: '該当する名前のユーザーはいません。' }
        format.json { render json: {erros: '該当するユーザーはありません。'}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipient_mail_users/1
  # PATCH/PUT /recipient_mail_users/1.json
  def update
    respond_to do |format|
      if @recipient_mail_user.update(recipient_mail_user_params)
        format.html { redirect_to @recipient_mail_user, notice: 'Recipient mail user was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient_mail_user }
      else
        format.html { render :edit }
        format.json { render json: @recipient_mail_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_mail_users/1
  # DELETE /recipient_mail_users/1.json
  def destroy
    respond_to do |format|
      if @mail_user
        @recipient = Recipient.find_by(recipient_list: @recipient_list, mail_user: @mail_user)
        @recipient.update_column(@attribute, false)
        if !@recipient.included && !@recipient.excluded && (@mail_user.mail_groups & @recipient_list.mail_groups).empty?
          @recipient.destroy
        end
        format.html { redirect_to @recipient_list, notice: '一覧からユーザーを削除しました。' }
        format.json { head :no_content }
      else
        format.html { redirect_to @recipient_list, alert: '該当する名前のユーザーはいません。' }
        format.json { render json: {erros: '該当するユーザーはありません。'}, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_recipient_list
      @recipient_list = RecipientList.find(params[:recipient_list_id])
      authorize @recipient_list
    end

    def set_attribute
      @attribute =
        if request.path_info.include?('included_mail_users')
          :included
        elsif request.path_info.include?('excluded_mail_users')
          :excluded
        end
    end

    def set_mail_user
      @mail_user = MailUser.find(params[:id])
    end

    def name_params
      params.permit(:name)
    end
end
