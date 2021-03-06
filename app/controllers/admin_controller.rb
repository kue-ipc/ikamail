# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authorize_admin

  def top
    authorize current_user, :admin?
  end

  def ldap_sync
    if LdapMailSyncJob.perform_later
      redirect_to admin_root_path, notice: 'LDAP同期を開始しました。'
    else
      redirect_to admin_root_path, alert: 'LDAP同期を開始できませんでした。'
    end
  end

  def statistics
    @year = params.permit(:year)['year']&.to_i || Time.current.then do |time|
      if time.month <= 3
        time.year - 1
      else
        time.year
      end
    end

    @begin_time = Time.zone.local(@year, 4, 1, 0, 0, 0)
    @end_time = @begin_time.since(1.year)
    @template_statistics = Template.all.map do |template|
      [
        template.id,
        {
          name: template.name,
          count: 0,
        }
      ]
    end.to_h
    BulkMail.where(status: 'delivered')
      .where(delivered_at: @begin_time...@end_time)
      .find_each do |bulk_mail|
      @template_statistics[bulk_mail.template_id].tap { |data| data[:count] += 1 }
    end
  end

  private
    def authorize_admin
      authorize current_user, :admin?
    end
end
