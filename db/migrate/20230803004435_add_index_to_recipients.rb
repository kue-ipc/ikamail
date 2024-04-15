class AddIndexToRecipients < ActiveRecord::Migration[7.0]
  def change
    add_index :recipients, [ :recipient_list_id, :mail_user_id ], unique: true
  end
end
