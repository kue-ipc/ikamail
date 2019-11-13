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

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: t_success_action(@user, :register) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to admin_users_path, alert: t_failure_action(@user, :register)  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    respond_to do |format|
      if current_user == @user
        format.html { redirect_to admin_users_path, alert: t(:cannot_modify_own, scope: :messages)}
        format.json { render json: {erros: t(:cannot_modify_own, scope: :messages)}, status: :unprocessable_entity }
      elsif @user.update(update_user_params)
        format.html { redirect_to admin_users_path, notice: t_success_action(@user, :update) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to admin_users_path, alert: t_failure_action(@user, :update)  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/sync
  def sync
    respond_to do |format|
      if LdapUserSyncJob.perform_later
        format.html { redirect_to admin_users_path, notice: 'LDAP同期を開始しました。'}
        format.json { render json: {notice: 'LDAP同期を開始しました。'}, status: :ok }
      else
        format.html { redirect_to admin_users_path, alert: 'LDAP同期を開始できませんでした。'}
        format.json { render json: {alert: 'LDAP同期を開始できませんんでした。'}, status: :unprocessable_entity }
      end
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
