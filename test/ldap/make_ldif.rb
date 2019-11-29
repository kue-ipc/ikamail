# frozen_strcing_literal: true

require 'base64'

def user_ldif(num)
  cn = "ts#{num}"

  <<~LDIF
    dn: uid=#{cn},ou=Users,dc=example,dc=jp
    objectClass: posixAccount
    objectClass: top
    objectClass: inetOrgPerson
    objectClass: organizationalPerson
    objectClass: person
    cn: #{cn}
    gidNumber: 100
    homeDirectory: /home/#{cn}
    sn: Sato
    sn;lang-ja:: #{Base64.strict_encode64('佐藤')}
    uid: #{cn}
    uidNumber: #{num + 2000}
    displayName: Sato #{num}rou
    displayName;lang-ja:: #{Base64.strict_encode64('佐藤　' + num.to_s + '郎')}
    givenName: #{num}rou
    givenName;lang-ja:: #{Base64.strict_encode64(num.to_s + '郎')}
    mail: #{cn}@example.jp
    userPassword: pass#{num}
  LDIF
end

if $0 == __FILE__
  (0..10000).each do |num|
    puts user_ldif(num)
    puts
  end
end
