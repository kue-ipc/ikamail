class CreateBulkMails < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mails do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :template, null: false, foreign_key: true

      t.integer :delivery_timing, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.datetime :delivered_at
      t.integer :number
      t.integer :status, null: false

      t.timestamps
    end
    add_index :bulk_mails, :status
    add_index :bulk_mails, :delivery_timing
  end
end
