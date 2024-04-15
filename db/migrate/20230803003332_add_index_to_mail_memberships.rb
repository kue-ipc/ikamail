class AddIndexToMailMemberships < ActiveRecord::Migration[7.0]
  def change
    add_index :mail_memberships, [ :mail_user_id, :mail_group_id ]
  end
end
