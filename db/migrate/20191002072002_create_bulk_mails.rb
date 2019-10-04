class CreateBulkMails < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mails do |t|
      t.belongs_to :owner, null: false, foreign_key: {to_table: :users}
      t.belongs_to :bulk_mail_template, null: false, foreign_key: true
      t.boolean :immediate_delivery, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.datetime :delivery_datetime
      t.integer :number
      t.string :status, null: false

      t.timestamps
    end
  end
end
