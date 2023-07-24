class CreateMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_templates do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false, default: true

      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :recipient_list, null: false, foreign_key: true

      t.string :from_name
      t.string :from_mail_address, null: false
      t.string :subject_prefix
      t.string :subject_suffix
      t.text :body_header
      t.text :body_footer

      t.integer :count, null: false, default: 0

      # reserved
      t.time :reserved_time, null: false

      t.text :description

      t.timestamps
    end
    add_index :mail_templates, :name, unique: true
  end
end
