class CreateBulkMails < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mails do |t|
      t.belongs_to :mail_template, null: false, foreign_key: true
      t.string :subject
      t.text :body
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :delivery_datetime
      t.integer :number
      t.belongs_to :mail_status, null: false, foreign_key: true

      t.timestamps
    end
  end
end
