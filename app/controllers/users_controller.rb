# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :authorize_user, only: [:index, :create, :sync]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = policy_scope(User).order(:username).page(params[:page])
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  # GET /user
  def show
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(create_user_params)
    @user.sync_ldap!

    if @user.save
      redirect_to admin_users_path, notice: t_success_action(@user, :register)
    else
      redirect_to admin_users_path, alert: t_failure_action(@user, :register)
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    if current_user == @user
      redirect_to admin_users_path, alert: t(:cannot_modify_own, scope: :messages)
    elsif @user.update(update_user_params)
      redirect_to admin_users_path, notice: t_success_action(@user, :update)
    else
      redirect_to admin_users_path, alert: t_failure_action(@user, :update)
    end
  end

  # PUT /admin/users/sync
  def sync
    if LdapUserSyncJob.perform_later
      redirect_to admin_users_path, notice: 'LDAP同期を開始しました。'
    else
      redirect_to admin_users_path, alert: 'LDAP同期を開始できませんでした。'
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user =
        if params[:id]
          User.find(params[:id])
        else
          current_user
        end
      authorize @user
    end

    def authorize_user
      authorize User
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_user_params
      params.require(:user).permit(:username)
    end

    def update_user_params
      params.require(:user).permit(:role)
    end
end
