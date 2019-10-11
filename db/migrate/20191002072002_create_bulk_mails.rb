class CreateBulkMails < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mails do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :bulk_mail_template, null: false, foreign_key: true

      t.string :delivery_timing, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.datetime :delivery_datetime
      t.integer :number
      t.string :status, null: false

      t.timestamps
    end
    add_index :bulk_mails, :status
    add_index :bulk_mails, :delivery_timing
  end
end
