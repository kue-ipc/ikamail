class CreateBulkMailActions < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mail_actions do |t|
      t.belongs_to :bulk_mail, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :action, null: false
      t.text :comment

      t.timestamps
    end
    add_index :bulk_mail_actions, :action
  end
end
