# frozen_string_literal: true

require 'set'

class CollectRecipientJob < ApplicationJob
  queue_as :default

  def perform(recipient_list_id)
    recipient_list = RecipientList.find(recipient_list_id)
    # TODO: 1 + N 問題あり
    new_set = Set.new(recipient_list.mail_groups.map(&:mail_user_ids).sum)
    cur_set = Set.new(recipient_list.mail_user_ids)

    # 新しい集合にないものを削除
    (cur_set - new_set).each do |mail_user_id|
      recipient = recipient_list.recipients.where(mail_user_id: mail_user_id).first
      # フラグ付きは除外
      if recipient && !recipient.included && !recipient.excluded
        recipient.destroy
      end
    end

    # 現在の集合にないものを作成
    (new_set - cur_set).each do |mail_user_id|
      recipient_list.recipients.create(mail_user_id: mail_user_id)
    end
  end
end
