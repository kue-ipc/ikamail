
require 'set'

class LdapAlignJob < ApplicationJob
  queue_as :default

  def perform(*args)
    align_groups
    align_users
    align_memberships
  end

  private def align_groups
    mail_group_remains = Set.new(MailGroup.all.map(&:name))

    LdapGroup.all.each do |group|
      name = group.name
      mail_group_remains.delete(name)
      MailGroup.find_and_create_by(name: name)
        .update(display_name: group.display_name)
    end

    # delete group out of LDAP
    mail_group_remains.each do |name|
      MailGroup.find_by(name: name).delete
    end
  end

  private def align_users
    mail_user_remains = Set.new(MailUser.all.map(&:name))

    LdapUser.all.each do |user|
      name = user.name
      mail_user_remains.delete(name)
      MailUser.find_and_create_by(name: name)
        .update(display_name: user.display_name)
    end

    # delete user out of LDAP
    mail_user_remains.each do |name|
      MailUser.find_by(name: name).delete
    end
  end

  private def align_memberships
    # MailGroup.find_each do |group|
    #   group_users = Set.new(group.users.map(&:name))
    #   ldap_group = LdapGroup.find_by_name(group.name)
    #   ldap_users = Set.new(ldap_group.primary_users.map(&:name) +
    #                 ldap_group.users.map(&:name))
    #
    #   (ldap_users - group_users).each do |username|
    #     group.users.add(MailUser.find_by(name: username))
    #   end
    #
    #   (group_users - ldap_users).each do |username|
    #     group.usels.delete()
    #
    # end
  end
end
