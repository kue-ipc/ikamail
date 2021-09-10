class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_type
  before_action :set_mail_user, only: [:destroy]

  # GET /recipient_lists/1/mail_users/included
  # GET /recipient_lists/1/mail_users/included
  def index
    all_mail_users =
      case @type
      when 'applicable'
        @recipient_list.applicable_mail_users
      when 'included'
        @recipient_list.included_mail_users
      when 'excluded'
        @recipient_list.excluded_mail_users
      end&.order(:name)

    @mail_users =
      if params[:page] == 'all'
        all_mail_users&.page(nil)&.per(all_mail_users&.count)
      else
        all_mail_users&.page(params[:page])
      end

    flash.alert = '指定のリストはありません。' if @mail_users.nil?
  end

  # POST /recipient_lists/1/mail_users/included
  # POST /recipient_lists/1/mail_users/included.json
  def create
    @mail_user = MailUser.find_by(name_params)

    if !['included', 'excluded'].include?(@type)
      redirect_to @recipient_list, alert: '指定のリストにユーザーは追加できません。'
    elsif @mail_user
      @recipient = Recipient.find_or_create_by(recipient_list: @recipient_list, mail_user: @mail_user)
      @recipient.update_column(@type, true)

      redirect_to @recipient_list, notice: '指定のリストにユーザーを追加しました。'
    else
      redirect_to @recipient_list, alert: '該当する名前のユーザーはいません。'
    end
  end

  # DELETE /recipient_lists/1/mail_users/included/1
  # DELETE /recipient_lists/1/mail_users/included/1.json
  def destroy
    @recipient = Recipient.find_by(recipient_list: @recipient_list, mail_user: @mail_user)

    if !['included', 'excluded'].include?(@type)
      redirect_to @recipient_list, alert: '指定のリストからユーザーは削除できません。'
    elsif @recipient
      @recipient.update_column(@type, false)
      if !@recipient.included && !@recipient.excluded &&
         (@mail_user.mail_groups & @recipient_list.mail_groups).empty?
        @recipient.destroy
      end
      redirect_to @recipient_list, notice: '指定のリストからユーザーを削除しました。'
    else
      redirect_to @recipient_list, alert: 'ユーザーはリストに含まれていません。'
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
