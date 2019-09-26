class CreateMailGroupsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_groups_users do |t|
      t.belongs_to :mail_group
      t.belongs_to :mail_user
    end
  end
end
