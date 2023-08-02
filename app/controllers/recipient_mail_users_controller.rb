class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_type
  before_action :set_mail_user, only: [:destroy]

  # GET /recipient_lists/1/mail_users/included
  # GET /recipient_lists/1/mail_users/included.json
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

    @mail_users = if params[:page] == 'all'
      all_mail_users&.page(nil)&.per(all_mail_users&.count)
    else
      all_mail_users&.page(params[:page])
    end

    flash.alert = '指定のリストはありません。' if @mail_users.nil?
  end

  # POST /recipient_lists/1/mail_users/included
  # POST /recipient_lists/1/mail_users/included.json
  def create
    if ['included', 'excluded'].exclude?(@type)
      redirect_to @recipient_list, alert: t('messages.cannot_add_mail_user_to_recipient_list')
      return
    end

    names = names_params
    if names.empty?
      redirect_to @recipient_list, alert: t('messages.no_mail_user_name')
      return
    end

    Recipient.transaction do
      mail_users = MailUser.where(name: names).or(MailUser.where(mail: names))
      Recipient.where(recipient_list: @recipient_list, mail_user: mail_users, @type => true).count
      Recipient.where(recipient_list: @recipient_list, mail_user: mail_users, @type => false).update(@type => true)

      mail_users.eager_load(:recipient_lists).where.not(recipient_lists: @recipient_list).find_each do |mail_user|
        Recipient.create(recipient_list: @recipient_list, mail_user: mail_user, @type => true)
      end
    end

    redirect_to @recipient_list, notice: t('messages.add_mail_user_to_recipient_list')
  end

  # DELETE /recipient_lists/1/mail_users/included/1
  # DELETE /recipient_lists/1/mail_users/included/1.json
  def destroy
    @recipient = Recipient.find_by(recipient_list: @recipient_list, mail_user: @mail_user)

    if ['included', 'excluded'].exclude?(@type)
      redirect_to @recipient_list, alert: '指定のリストからユーザーは削除できません。'
    elsif @recipient
      @recipient.update(@type => false)
      if !@recipient.included && !@recipient.excluded &&
         (@mail_user.mail_groups & @recipient_list.mail_groups).empty?
        @recipient.destroy
      end
      redirect_to @recipient_list, notice: '指定のリストからユーザーを削除しました。'
    else
      redirect_to @recipient_list, alert: 'ユーザーはリストに含まれていません。'
    end
  end

  private def set_recipient_list
    @recipient_list = RecipientList.find(params[:id])
    authorize @recipient_list
  end

  private def set_type
    @type = params[:type]
    authorize Recipient
  end

  private def set_mail_user
    @mail_user = MailUser.find(params[:mail_user_id])
  end

  private def names_params
    if params[:file]
      params[:file].read
    else
      params[:name] || ''
    end.split(/[\s,\ufeff]/).map(&:strip).select(&:present?)
  end
end
