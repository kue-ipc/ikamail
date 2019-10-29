class MailUsersController < ApplicationController
  before_action :set_mail_user, only: [:show]
  before_action :authorize_mail_user, only: [:index]

  # GET /mail_users
  # GET /mail_users.json
  def index
    @mail_users = policy_scope(MailUser).order(:name).page(params[:page])
  end

  # GET /mail_users/1
  # GET /mail_users/1.json
  def show
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_user_params
      params.fetch(:mail_user, {})
    end
end
