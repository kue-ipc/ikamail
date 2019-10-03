class CreateBulkMails < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mails do |t|
      t.belongs_to :bulk_mail_template, null: false, foreign_key: true
      t.boolean :immediate_delivery, null: false
      t.string :subject
      t.text :body
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :delivery_datetime
      t.integer :number
      t.string :status

      t.timestamps
    end
  end
end
