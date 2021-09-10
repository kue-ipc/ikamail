class CreateMailGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_groups do |t|
      t.string :name, null: false
      t.string :display_name

      t.timestamps
    end
    add_index :mail_groups, :name, unique: true
  end
end
