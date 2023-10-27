class MailUsersController < ApplicationController
  before_action :set_mail_user, only: [:show]
  before_action :authorize_mail_user, only: [:index]

  # GET /mail_users
  # GET /mail_users.json
  def index
    all_mail_users = if search_params[:mail_group_id].present?
      MailGroup.find(search_params[:mail_group_id]).mail_users
    else
      MailUser
    end

    all_mail_users = all_mail_users.where("name LIKE ?", "#{search_params[:query]}%") if search_params[:query].present?

    @mail_users = policy_scope(all_mail_users).order(:name).page(params[:page])
  end

  # GET /mail_users/1
  # GET /mail_users/1.json
  def show
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_mail_user
    @mail_user = policy_scope(MailUser).find(params[:id])
    authorize @mail_user
  end

  private def authorize_mail_user
    authorize MailUser
  end

  private def search_params
    params.permit(:mail_group_id, :query)
  end
end
