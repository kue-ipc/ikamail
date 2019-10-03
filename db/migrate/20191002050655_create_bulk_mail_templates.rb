class CreateBulkMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_mail_templates do |t|
      t.string :name, index: {unique: true}, null: false
      t.belongs_to :recipient_list, null: false
      t.string :from_name
      t.string :from_mail_address, null: false
      t.string :subject_prefix
      t.string :subject_postfix
      t.text :body_header
      t.text :body_footer
      t.integer :count
      t.time :reservation_time
      t.text :description

      t.timestamps
    end
  end
end
