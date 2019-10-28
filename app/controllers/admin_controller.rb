class AdminController < ApplicationController
  def top
    authorize current_user, :admin?
  end

  def ldap_sync
    authorize MailUser, :update?

    respond_to do |format|
      if LdapUserSyncJob.perform_later && LdapMailSyncJob.perform_later
        format.html { redirect_to admin_root_path, notice: '同期処理開始ジョブを登録しました。'}
        format.json { render json: {notice: '同期処理開始ジョブを登録しました。'}, status: :ok }
      else
        format.html { redirect_to admin_root_path, error: '同期処理開始ジョブ登録に失敗しました。'}
        format.json { render json: {error: '同期処理開始ジョブ登録に失敗しました。'}, status: :unprocessable_entity }
      end
    end
  end

  def statistics
  end
end
