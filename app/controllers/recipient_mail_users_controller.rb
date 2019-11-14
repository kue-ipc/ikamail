# frozen_string_literal: true

class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_type
  before_action :set_mail_user, only: [:destroy]

  # GET /recipient_lists/1/mail_users/included
  # GET /recipient_lists/1/mail_users/included
  def index
    @mail_users =
      case @type
      when 'applicable'
        @recipient_list.applicable_mail_users
      when 'included'
        @recipient_list.included_mail_users
      when 'excluded'
        @recipient_list.excluded_mail_users
      end&.order(:name)&.page(params[:page])
    flash.alert = '指定のリストはありません。' if @mail_users.nil?
  end

  # POST /recipient_lists/1/mail_users/included
  # POST /recipient_lists/1/mail_users/included.json
  def create
    @mail_user = MailUser.find_by(name_params)

    respond_to do |format|
      if !['included', 'excluded'].include?(@type)
        format.html { redirect_to @recipient_list, alert: '指定のリストにユーザーは追加できません。' }
        format.json { render json: {erros: '指定のリストにユーザーは追加できません。'}, status: :unprocessable_entity }
      elsif @mail_user
        @recipient = Recipient.find_or_create_by(recipient_list: @recipient_list, mail_user: @mail_user)
        @recipient.update_column(@type, true)

        format.html { redirect_to @recipient_list, notice: '指定のリストにユーザーを追加しました。' }
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        format.html { redirect_to @recipient_list, alert: '該当する名前のユーザーはいません。' }
        format.json { render json: {erros: '該当する名前のユーザーはいません。'}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_lists/1/mail_users/included/1
  # DELETE /recipient_lists/1/mail_users/included/1.json
  def destroy
    @recipient = Recipient.find_by(recipient_list: @recipient_list, mail_user: @mail_user)

    respond_to do |format|
      if !['included', 'excluded'].include?(@type)
        format.html { redirect_to @recipient_list, alert: '指定のリストからユーザーは削除できません。' }
        format.json { render json: {erros: '指定のリストからユーザーは削除できません。'},
                             status: :unprocessable_entity }
      elsif @recipient
        @recipient.update_column(@type, false)
        if !@recipient.included && !@recipient.excluded &&
            (@mail_user.mail_groups & @recipient_list.mail_groups).empty?
          @recipient.destroy
        end
        format.html { redirect_to @recipient_list, notice: '指定のリストからユーザーを削除しました。' }
        format.json { head :no_content }
      else
        format.html { redirect_to @recipient_list, alert: 'ユーザーはリストに含まれていません。' }
        format.json { render json: {erros: 'ユーザーはリストに含まれていません。'}, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_recipient_list
      @recipient_list = RecipientList.find(params[:id])
      authorize @recipient_list
    end

    def set_type
      @type = params[:type]
      authorize Recipient
    end

    def set_mail_user
      @mail_user = MailUser.find(params[:mail_user_id])
    end

    def name_params
      params.permit(:name)
    end
end
