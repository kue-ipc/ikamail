require 'set'

class LdapSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sync_groups
    sync_users
    sync_memberships
  end

  private def sync_groups
    mail_group_remains = Set.new(MailGroup.all.map(&:name))

    LdapGroup.all.each do |group|
      name = group.name
      mail_group_remains.delete(name)
      MailGroup.find_or_create_by(name: name)
        .update(display_name: group.display_name)
    end

    # delete group out of LDAP
    mail_group_remains.each do |name|
      MailGroup.find_by(name: name).delete
    end
  end

  private def sync_users
    mail_user_remains = Set.new(MailUser.all.map(&:name))

    LdapUser.all.each do |user|
      name = user.name
      mail_user_remains.delete(name)
      MailUser.find_or_create_by(name: name, mail: user.mail)
        .update(display_name: user.display_name)
    end

    # delete user out of LDAP
    mail_user_remains.each do |name|
      MailUser.find_by(name: name).delete
    end
  end

  private def sync_memberships
    MailGroup.find_each do |group|
      ldap_group = LdapGroup.find_by_name(group.name)
      group.mail_users = MailUser.where(
        name: ldap_group.primary_users.map(&:name) |
              ldap_group.users.map(&:name)
      ).all
    end
  end
end
