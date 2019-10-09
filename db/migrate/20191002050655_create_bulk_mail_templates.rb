class CreateBulkMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mail_templates do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false, default: true

      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :recipient_list, null: false, foreign_key: true

      t.string :from_name
      t.string :from_mail_address, null: false
      t.string :subject_prefix
      t.string :subject_postfix
      t.text :body_header
      t.text :body_footer

      t.integer :count, null: false, default: 0

      # reservation
      t.integer :reservation_hour, null: false, default: 0
      t.integer :reservation_minute, null: false, default: 0

      t.text :description

      t.timestamps
    end
    add_index :bulk_mail_templates, :name, unique: true
  end
end
