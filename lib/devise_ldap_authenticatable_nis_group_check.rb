# RFC 2307 LDAP as a NIS
# setting: config.ldap_nis_group_check

require "devise"
require "devise_ldap_authenticatable"

module Devise
  mattr_accessor :ldap_nis_group_check
  @@ldap_nis_group_check = false # rubocop: disable Style/ClassVars

  module LDAP
    DEFAULT_GID_NUMBER_KEY = "gidNumber".freeze
    DEFAULT_MEMBER_UID_KEY = "memberUid".freeze
    DEFAULT_UID_KEY = "uid".freeze

    class Connection
      def gid_number
        @gid_number ||= ldap_param_value(LDAP::DEFAULT_GID_NUMBER_KEY)[0].to_i
      end

      def uid
        @uid ||= ldap_param_value(LDAP::DEFAULT_UID_KEY)[0]
      end

      def in_group_nis?(group_name)
        in_group = false

        group_checking_ldap = if @check_group_membership_without_admin
          @ldap
        else
          Connection.admin
        end

        group_checking_ldap.search(base: group_name,
          scope: Net::LDAP::SearchScope_BaseObject) do |entry|
          if entry[LDAP::DEFAULT_GID_NUMBER_KEY][0].to_i == gid_number
            in_group = true
            DeviseLdapAuthenticatable::Logger.send("User #{dn} is included in nis primary group: #{group_name}")
          elsif entry[LDAP::DEFAULT_MEMBER_UID_KEY].include?(uid)
            in_group = true
            DeviseLdapAuthenticatable::Logger.send("User #{dn} is included in nis group: #{group_name}")
          end
        end

        DeviseLdapAuthenticatable::Logger.send("User #{dn} is not in nis group: #{group_name}") unless in_group

        in_group
      end

      # overwrite in_group?
      alias _in_group? in_group?
      def in_group?(group_name,
                    group_attribute = LDAP::DEFAULT_GROUP_UNIQUE_MEMBER_LIST_KEY)
        if ::Devise.ldap_nis_group_check
          in_group_nis?(group_name)
        else
          _in_group?(group_name, group_attribute)
        end
      end
    end
  end
end
