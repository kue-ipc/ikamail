# frozen_string_literal: true

class AdminController < ApplicationController
  def top
    authorize current_user, :admin?
  end

  def ldap_sync
    authorize MailUser, :update?

    respond_to do |format|
      if LdapMailSyncJob.perform_later
        format.html { redirect_to admin_root_path, notice: 'LDAP同期を開始しました。'}
        format.json { render json: {notice: 'LDAP同期を開始しました。'}, status: :ok }
      else
        format.html { redirect_to admin_root_path, alert: 'LDAP同期を開始できませんでした。'}
        format.json { render json: {alert: 'LDAP同期を開始できませんんでした。'}, status: :unprocessable_entity }
      end
    end
  end

  def statistics
  end
end
