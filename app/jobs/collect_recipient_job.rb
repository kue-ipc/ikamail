require 'set'

class CollectRecipientJob < ApplicationJob
  queue_as :default

  def perform(recipient_list)
    # TODO: 1 + N 問題あり
    new_set = Set.new(recipient_list.mail_groups.flat_map(&:mail_user_ids))
    cur_set = Set.new(recipient_list.mail_user_ids)

    # 新しい集合にないものを削除
    (cur_set - new_set).each do |mail_user_id|
      recipient = recipient_list.recipients.where(mail_user_id: mail_user_id).first
      # フラグ付きは除外
      recipient.destroy if recipient && !recipient.included && !recipient.excluded
    end

    # 現在の集合にないものを作成
    (new_set - cur_set).each do |mail_user_id|
      recipient_list.recipients.create(mail_user_id: mail_user_id)
    end
  end
end
