require "ldap/server"
require "ldap/server/schema"

require_relative "helpers/ldif_read_operation"

ldif_list = %w[base groups people].map do |name|
  File.join(__dir__, "ldap", "ldif", "#{name}.ldif")
end
schema_list = %w[core cosine inetorgperson nis gakunin].map do |name|
  File.join(__dir__, "ldap", "schema", "#{name}.schema")
end
schema = LDAP::Server::Schema.new
schema.load_system
# NOTE: add some attributes because these are not included in system schema
schema.load(<<-EOS)
attributetype ( 2.5.4.13 NAME 'description'
	DESC 'RFC2256: descriptive information'
	EQUALITY caseIgnoreMatch
	SUBSTR caseIgnoreSubstringsMatch
	SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{1024} )
attributetype ( 2.5.4.34 NAME 'seeAlso'
	DESC 'RFC2256: DN of related object'
	SUP distinguishedName )
attributetype ( 0.9.2342.19200300.100.1.1
	NAME ( 'uid' 'userid' )
	DESC 'RFC1274: user identifier'
	EQUALITY caseIgnoreMatch
	SUBSTR caseIgnoreSubstringsMatch
	SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )
attributetype ( 1.3.6.1.1.1.1.0 NAME 'uidNumber'
	DESC 'An integer uniquely identifying a user in an administrative domain'
	EQUALITY integerMatch
	SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )
attributetype ( 1.3.6.1.1.1.1.1 NAME 'gidNumber'
	DESC 'An integer uniquely identifying a group in an administrative domain'
	EQUALITY integerMatch
	SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )
EOS

schema_list.each { |path| schema.load_file(path) }
schema.resolve_oids

server = LDAP::Server.new(
  port: 1389,
  nodelay: true,
  listen: 10,
  operation_class: LdifReadOperation,
  operation_args: [*ldif_list],
  schema: schema,
  namingContexts: ["dc=example,dc=jp"],
)
server.logger.level = Logger::DEBUG
server.run_tcpserver
server.join
