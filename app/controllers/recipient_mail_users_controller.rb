class RecipientMailUsersController < ApplicationController
  before_action :set_recipient_list
  before_action :set_type

  # GET /recipient_lists/1/mail_users/included
  # GET /recipient_lists/1/mail_users/included.json
  def index
    unless [:applicable, :included, :excluded].include?(@type)
      return redirect_to @recipient_list, alert: t("messages.not_found_recipient_list_type")
    end

    @attr_name = "#{@type}_mail_users".intern
    @mail_users = @recipient_list.__send__(@attr_name).order(:name)
    @mail_users = @mail_users.page(params[:page]) if params[:page] != "all"
  end

  # POST /recipient_lists/1/mail_users/included
  # POST /recipient_lists/1/mail_users/included.json
  def create
    if [:included, :excluded].exclude?(@type)
      return redirect_to @recipient_list, alert: t("messages.cannot_add_mail_user_to_recipient_list")
    end

    names = names_params
    return redirect_to @recipient_list, alert: t("messages.no_mail_user_name") if names.empty?

    count = create_or_update_for_type(names)

    remaining_names = not_included_names(names, @recipient_list.mail_users)

    alert = ("#{t('messages.not_found_mail_user')}: #{remaining_names.join(', ')}" unless remaining_names.empty?)

    notice =
      if count.zero?
        t("messages.no_mail_user_to_add")
      else
        "#{count} #{t('messages.success_action', model: t('activerecord.models.mail_user'), action: t('actions.add'))}"
      end

    redirect_to @recipient_list, notice: notice, alert: alert
  rescue ActiveRecord::ActiveRecordError => e
    redirect_to @recipient_list, alert: [
      t("messages.failure_action", model: t("activerecord.models.mail_user"), action: t("actions.add")),
      e.message,
    ]
  rescue EncodingError
    redirect_to @recipient_list, alert: [
      t("messages.failure_action", model: t("activerecord.models.mail_user"), action: t("actions.add")),
      t("messages.not_utf8"),
    ]
  end

  # DELETE /recipient_lists/1/mail_users/included/1
  # DELETE /recipient_lists/1/mail_users/included/1.json
  def destroy
    if [:included, :excluded].exclude?(@type)
      redirect_to @recipient_list, alert: t("messages.cannot_remove_mail_user_to_recipient_list")
      return
    end

    recipients = @recipient_list.recipients.where(@type => true)
    recipients = recipients.where(mail_user_id: params[:mail_user_id]) if params[:mail_user_id]

    if recipients.count.zero?
      redirect_to @recipient_list, notice: t("messages.no_mail_user_in_recipent_list")
      return
    end

    if recipients.update({@type => false})
      @recipient_list.update(collected: false)
      CollectRecipientJob.perform_later(@recipient_list)
      redirect_to @recipient_list,
        notice: t("messages.success_action", model: t("activerecord.models.mail_user"), action: t("actions.delete"))
    else
      redirect_to @recipient_list,
        alert: t("messages.failure_action", model: t("activerecord.models.mail_user"), action: t("actions.delete"))
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
      params[:file].read.force_encoding(Encoding::UTF_8).tap do |data|
        raise EncodingError, "Invalid encoding" unless data.valid_encoding?
      end
    else
      params[:name] || ""
    end.split(/[\s,\ufeff]/).map(&:strip).select(&:present?).map(&:downcase)
  end

  private def create_or_update_for_type(names)
    count = 0
    Recipient.transaction do
      MailUser.eager_load(:recipients).where(name: names).or(MailUser.where(mail: names)).find_each do |mail_user|
        recipient = mail_user.recipients.to_a.find { |r| r.recipient_list_id == @recipient_list.id }
        if recipient.nil?
          mail_user.recipients.create!({recipient_list: @recipient_list, @type => true})
          count += 1
        elsif !recipient.__send__(@type)
          recipient.update!(@type => true)
          count += 1
        end
      end
    end
    count
  end

  private def not_included_names(names, mail_users)
    remaining_names = Set.new(names)
    mail_users.each do |mail_user|
      remaining_names.delete(mail_user.name)
      remaining_names.delete(mail_user.mail)
    end
    remaining_names.to_a
  end
end
