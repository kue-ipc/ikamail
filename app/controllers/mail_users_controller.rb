# frozen_string_literal: true

class MailUsersController < ApplicationController
  before_action :set_mail_user, only: [:show]
  before_action :authorize_mail_user, only: [:index]

  # GET /mail_users
  # GET /mail_users.json
  def index
    all_mail_users =
      if params[:mail_group_id].present?
        MailGroup.find(params[:mail_group_id]).mail_users
      elsif params[:recipient_list_id].present?
        RecipientList.find(params[:recipient_list_id]).applicable_mail_users
      else
        MailUser
      end
    @mail_users = policy_scope(all_mail_users).order(:name).page(params[:page])
  end

  # GET /mail_users/1
  # GET /mail_users/1.json
  def show
  end

  # POST /search/mail_users
  # POST /search/mail_users.json
  def search
    authorize MailUser
    @query = search_params[:query] || ''
    if @query.present?
      @mail_users = MailUser.where('name LIKE ?', "#{@query}%")
        .or(MailUser.where('display_name LIKE ?', "#{@query}%"))
        .or(MailUser.where('mail LIKE ?', "#{@query}%"))
        .order(:name).limit(10)
    else
      @mail_users = MailUser.none
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_user
      @mail_user = MailUser.find(params[:id])
      authorize @mail_user
    end

    def authorize_mail_user
      authorize MailUser
    end

    def search_params
      params.permit(:query)
    end
end
