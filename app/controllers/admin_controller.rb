# frozen_string_literal: true

class AdminController < ApplicationController
  def top
    authorize current_user, :admin?
  end

  def ldap_sync
    authorize MailUser, :update?

    if LdapMailSyncJob.perform_later
      redirect_to admin_root_path, notice: 'LDAP同期を開始しました。'
    else
      redirect_to admin_root_path, alert: 'LDAP同期を開始できませんでした。'
    end
  end

  def statistics
  end
end
