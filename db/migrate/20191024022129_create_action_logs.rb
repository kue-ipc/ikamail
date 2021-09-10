class CreateActionLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :action_logs do |t|
      t.belongs_to :bulk_mail, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :action, null: false
      t.text :comment

      t.timestamps
    end
    add_index :action_logs, :action
  end
end
