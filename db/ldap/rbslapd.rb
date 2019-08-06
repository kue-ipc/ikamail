#!/usr/bin/env ruby
# frozen_string_literal: true

# The orginal is one of the ruby-ldapserver examples.
# https://github.com/inscitiv/ruby-ldapserver
#
# ORGINAL COPYING
# ===============
# Copyright (c) 2005 Brian Candler
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# This is a trivial LDAP server which just stores directory entries in RAM.
# It does no validation or authentication. This is intended just to
# demonstrate the API, it's not for real-world use!!
# ==============

require 'ldap/server'

# We subclass the Operation class, overriding the methods to do what we need

class HashOperation < LDAP::Server::Operation
  def initialize(connection, message_id, hash)
    super(connection, message_id)
    @hash = hash # an object reference to our directory data
  end

  def search(basedn, scope, _deref, filter)
    basedn = basedn.downcase

    case scope
    when LDAP::Server::BaseObject
      # client asked for single object by DN
      obj = @hash[basedn]
      raise LDAP::ResultError::NoSuchObject unless obj

      if LDAP::Server::Filter.run(filter, obj)
        send_SearchResultEntry(obj['dn'], obj['attrs'])
      end

    when LDAP::Server::SingleLevel
      if basedn == ''
        first_dn = @hash.keys.first
        send_SearchResultEntry(@hash[first_dn]['dn'], @hash[first_dn]['attrs'])
        return
      end
      @hash.each do |dn, obj|
        next unless dn.end_with?(',' + basedn) # under basedn?
        next unless dn.count(',') - basedn.count(',') == 1
        next unless LDAP::Server::Filter.run(filter, obj['attrs']) # attribute filter?

        send_SearchResultEntry(obj['dn'], obj['attrs'])
      end
    when LDAP::Server::WholeSubtree
      @hash.each do |dn, obj|
        next unless dn.end_with?(',' + basedn) # under basedn?
        next unless LDAP::Server::Filter.run(filter, obj['attrs']) # attribute filter?

        send_SearchResultEntry(obj['dn'], obj['attrs'])
      end
    else
      raise LDAP::ResultError::UnwillingToPerform, 'Unknown scope'
    end
  end

  def add(dn, av)
    ldn = dn.downcase
    raise LDAP::ResultError::EntryAlreadyExists if @hash[ldn]

    @hash[ldn] = {
      'dn' => dn,
      'attrs' => av,
    }
  end

  def del(dn)
    ldn = dn.downcase
    raise LDAP::ResultError::NoSuchObject unless @hash.has_key?(ldn)

    @hash.delete(ldn)
  end

  def modify(dn, ops)
    ldn = dn.downcase
    entry = @hash[ldn]['attrs']
    raise LDAP::ResultError::NoSuchObject unless entry

    ops.each do |attr, vals|
      op = vals.shift
      case op
      when :add
        entry[attr] ||= []
        entry[attr] += vals
        entry[attr].uniq!
      when :delete
        if vals == []
          entry.delete(attr)
        else
          vals.each { |v| entry[attr].delete(v) }
        end
      when :replace
        entry[attr] = vals
      end
      entry.delete(attr) if entry[attr] == []
    end
  end
end

# This is the shared object which carries our actual directory entries.
# It's just a hash of {dn=>entry}, where each entry is {attr=>[val,val,...]}

directory = {}
data_yaml = File.expand_path('ldapdb.yml', __dir__)
# Let's put some backing store on it

require 'yaml'
begin
  File.open(data_yaml) { |f| directory = YAML.load(f.read) }
rescue Errno::ENOENT
end

# no save
# at_exit do
#   new_data_yaml = File.expand_path('ldapdb.new', __dir__)
#   File.open(new_data_yaml, 'w') { |f| f.write(YAML.dump(directory)) }
#   File.rename('ldapdb.new', data_yaml)
# end

# Listen for incoming LDAP connections. For each one, create a Connection
# object, which will invoke a HashOperation object for each request.

s = LDAP::Server.new(
  port: 1389,
  nodelay: true,
  listen: 10,
  # ssl_key_file: File.expand_path('key.pem', __dir__),
  # ssl_cert_file: File.expand_path('cert.pem', __dir__),
  # ssl_on_connect: true,
  operation_class: HashOperation,
  operation_args: [directory])
s.run_tcpserver
s.join
