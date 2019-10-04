class CreateBulkMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mail_templates do |t|
      t.integer :number, null: false, default: 0
      t.boolean :enabled, null: false, default: true
      t.string :name, null: false
      t.belongs_to :recipient_list, null: false
      t.string :from_name
      t.string :from_mail_address, null: false
      t.string :subject_prefix
      t.string :subject_postfix
      t.text :body_header
      t.text :body_footer
      t.integer :count, null: false, default: 0
      t.time :reservation_time
      t.text :description

      t.timestamps
    end
    add_index :bulk_mail_templates, :name, unique: true
  end
end
