class CreateMailGroupsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_groups_users do |t|
      t.belongs_to :mail_group, null: false, foreign_key: true
      t.belongs_to :mail_user, null: false, foreign_key: true
    end
  end
end
