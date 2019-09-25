# メールアドレスのすり合わせを行うジョブ
# DB上にあって、LDAP上にない場合は、DBから削除する。
# DB上になくて、LDAP上にある場合は、DBに追加する。

require 'set'

class MailAddressAlignJob < ApplicationJob
  queue_as :default

  def perform(*args)
    mail_user_remains = Set.new(MailAddress.all.map(&:name))
    LdapUser.all.each do |user|
      if mail_user_remains.delete?(user.name)
        MailAddress.find_by(name: user.name)
          .update(address: user.mail, display_name: user.display_name)
      else
        MailAddress.create(
          name: user.name,
          address: user.mail,
          display_name: user.display_name
        )
      end
    end

    # no ldap user delete
    mail_user_remains.each do |name|
      MailAddress.find_by(name: user.name).delete
    end
  end
end
