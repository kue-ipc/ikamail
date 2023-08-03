class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_type

  # GET /recipient_lists/1/mail_users/included
  # GET /recipient_lists/1/mail_users/included.json
  def index
    unless [:applicable, :included, :excluded].include?(@type)
      return redirect_to @recipient_list, alert: t('messages.not_found_recipient_list_type')
    end

    @attr_name = "#{@type}_mail_users".intern
    @mail_users = @recipient_list.__send__(@attr_name).order(:name)
    @mail_users = @mail_users.page(params[:page]) if params[:page] != 'all'
  end

  # POST /recipient_lists/1/mail_users/included
  # POST /recipient_lists/1/mail_users/included.json
  def create
    if [:included, :excluded].exclude?(@type)
      return redirect_to @recipient_list, alert: t('messages.cannot_add_mail_user_to_recipient_list')
    end

    names = names_params
    return redirect_to @recipient_list, alert: t('messages.no_mail_user_name') if names.empty?

    count = 0
    Recipient.transaction do
      mail_users = MailUser.where(name: names).or(MailUser.where(mail: names))
      pp @recipient_list.recipients.where(mail_user: mail_users, @type => false).update!(@type => true)
      # mail_users.eager_load(:recipient_lists).where.not(recipient_lists: @recipient_list).find_each do |mail_user|
      #   pp mail_user
      #   @recipient_list.recipients.create!({mail_user: mail_user, @type => true})
      #   count += 1
      # end
    end

    remaining_names = Set.new(names)
    @recipient_list.mail_users.each do |mail_user|
      remaining_names.delete(mail_user.name)
      remaining_names.delete(mail_user.mail)
    end

    alert =
      if remaining_names.empty?
        nil
      else
        "#{t('messages.not_found_mail_user')}: #{remaining_names.join(', ')}"
      end

    redirect_to @recipient_list,
      notice: t('messages.success_action', model: t('activerecord.models.mail_user'), action: t('actions.add')),
      alert: alert
  rescue ActiveRecord::ActiveRecordError => e
    redirect_to @recipient_list,
      alert: [
        t('messages.failure_action', model: t('activerecord.models.mail_user'), action: t('actions.add')),
        e.message,
      ]
  end

  # DELETE /recipient_lists/1/mail_users/included/1
  # DELETE /recipient_lists/1/mail_users/included/1.json
  def destroy
    if [:included, :excluded].exclude?(@type)
      redirect_to @recipient_list, alert: t('messages.cannot_remove_mail_user_to_recipient_list')
      return
    end

    recipients = @recipient_list.recipients.where(@type => true)
    recipients = recipients.where(mail_user_id: params[:mail_user_id]) if params[:mail_user_id]

    if recipients.count.zero?
      redirect_to @recipient_list, notice: t('messages.no_mail_user_in_recipent_list')
      return
    end

    if recipients.update({@type => false})
      @recipient_list.update(collected: false)
      CollectRecipientJob.perform_later(@recipient_list)
      redirect_to @recipient_list,
        notice: t('messages.success_action', model: t('activerecord.models.mail_user'), action: t('actions.delete'))
    else
      redirect_to @recipient_list,
        alert: t('messages.failure_action', model: t('activerecord.models.mail_user'), action: t('actions.delete'))
    end
  end

  private def set_recipient_list
    @recipient_list = RecipientList.find(params[:id])
  end

  private def set_type
    @type = params[:type].intern
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
