require 'set'

class CollectRecipientJob < ApplicationJob
  queue_as :default

  # TODO: 1 + N 問題あり
  def perform(recipient_list)
    # 最新のBulkMailを取得する
    recipient_list = RecipientList.find(recipient_list.id)
    return if recipient_list.nil?
    # 二重実行チェック
    return if recipient_list.collected

    recipient_list.with_lock do
      new_set = Set.new(recipient_list.mail_groups.flat_map(&:mail_user_ids))
      cur_set = Set.new(recipient_list.mail_user_ids)

      # 新しい集合にないものを削除
      recipient_list.recipients
        .where(mail_user_id: (cur_set - new_set).to_a, included: false, excluded: false)
        .find_each(&:destroy!)

      # 現在の集合にないものを作成
      (new_set - cur_set).each do |mail_user_id|
        recipient_list.recipients.create!(mail_user_id: mail_user_id)
      end
      recipient_list.update!(collected: true)
    end
  end
end
