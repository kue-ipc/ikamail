# メールアドレスのすり合わせを行うジョブ
# DB上にあって、LDAP上にない場合は、DBから削除する。
# DB上になくて、LDAP上にある場合は、DBに追加する。

class MailAddressAlignJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
