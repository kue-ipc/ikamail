class LdapUserSyncJob < ApplicationJob
  queue_as :default

  def perform
    sync_users
  end

  private def sync_users
    User.where(deleted: false).each do |user|
      if user.ldap_entry
        user.sync_ldap!
      else
        user.username = "##{user.id}##{user.username}"
        user.deleted = true
      end
      user.save
    end
  end
end
