# fix active_ldap
require "fix_active_ldap"

class LdapMailSyncJob < ApplicationJob
  queue_as :default

  after_perform do
    CollectRecipientAllJob.perform_later
  end

  def perform
    sync_mail_groups
    sync_mail_users
    sync_mail_memberships
  end

  private def sync_mail_groups
    mail_group_remains = Set.new(MailGroup.all.map(&:name))

    LdapGroup.all.each do |group|
      name = group.name.downcase
      mail_group_remains.delete(name)
      MailGroup.find_or_create_by(name: name).update(display_name: group.display_name)
    end

    # delete group out of LDAP
    mail_group_remains.each do |name|
      MailGroup.find_by(name: name).destroy
    end
  end

  private def sync_mail_users
    mail_user_remains = Set.new(MailUser.all.map(&:name))

    LdapUser.all.each do |user|
      # ignore user who dose not have mail addresses
      next unless user.mail

      name = user.name.downcase
      mail_user_remains.delete(name)
      mail_user = MailUser.find_or_initialize_by(name: name)
      mail_user.mail = user.mail.downcase
      mail_user.display_name = user.display_name
      mail_user.save
    end

    # delete user out of LDAP
    mail_user_remains.each do |name|
      MailUser.find_by(name: name).destroy
    end
  end

  private def sync_mail_memberships
    MailGroup.find_each do |group|
      ldap_group = LdapGroup.find_dn(group.name)
      group.primary_users = MailUser.where(name: ldap_group.primary_users.map(&:name).map(&:downcase)).all
      group.secondary_users = MailUser.where(name: ldap_group.users.map(&:name).map(&:downcase)).all
    end
  end
end
