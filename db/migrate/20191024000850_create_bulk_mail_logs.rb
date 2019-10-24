class CreateBulkMailLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mail_logs do |t|
      t.belongs_to :bulk_mail, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :action
      t.text :comment

      t.timestamps
    end
    add_index :bulk_mails, :action
  end
end
