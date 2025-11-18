require "ldap/server"
require "ldif_parser"

class LdifReadOperation < LDAP::Server::Operation
  def initialize(connection, messageID, *ldifs)
    super(connection, messageID)

    @data = {}
    ldifs.each do |path|
      LdifParser.open(path).each do |entry|
        next if entry.dn.nil?

        @data[entry.dn] = entry.transform_keys(&:to_s).freeze
      end
    end
    @data.freeze
  end

  def simple_bind(version, dn, password)
    if version != 3
      raise LDAP::ResultError::ProtocolError, "version 3 only"
    end

    return if dn.nil?

    # user bind
    entry = @directoy[dn]
    if entry && entry["userPassword"] && entry["userPassword"].include?(password)
      return
    end

    raise LDAP::ResultError::InvalidCredentials, "invalid credentials"
  end

  def search(basedn, scope, deref, filter)
    basedn = basedn.downcase

    case scope
    in LDAP::Server::BaseObject
      entry = @data[basedn]
      raise LDAP::ResultError::NoSuchObject, "no such entry" unless entry

      send_SearchResultEntry(basedn, entry) if LDAP::Server::Filter.run(filter, entry)
    in LDAP::Server::SingleLevel
      @data.each do |dn, entry|
        next unless dn.end_with?(",#{basedn}") && dn.count(",") == basedn.count(",") + 1

        if LDAP::Server::Filter.run(filter, entry)
          send_SearchResultEntry(dn, entry)
        end
      end
    in LDAP::Server::WholeSubtree
      @data.each do |dn, entry|
        next unless dn == basedn || dn.end_with?(",#{basedn}")

        if LDAP::Server::Filter.run(filter, entry)
          send_SearchResultEntry(dn, entry)
        end
      end
    end
  end

  def compare(entry, attr, val)
    entry = entry.downcase
    if @schema
      attr  = @schema.find_attrtype(attr ).to_s
    end

    entry_data = @data[entry]
    raise LDAP::ResultError::NoSuchObject, "no such entry" unless entry_data

    attr_values = entry_data[attr]
    raise LDAP::ResultError::NoSuchAttribute, "no such attribute" unless attr_values

    attr_values.include?(val)
  end
end
