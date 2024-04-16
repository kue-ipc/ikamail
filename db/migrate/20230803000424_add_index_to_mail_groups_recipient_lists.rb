class AddIndexToMailGroupsRecipientLists < ActiveRecord::Migration[7.0]
  def change
    add_index :mail_groups_recipient_lists,
      [ :mail_group_id, :recipient_list_id ],
      name: "index_mail_groups_recipient_lists_on_intermediate", unique: true
  end
end
