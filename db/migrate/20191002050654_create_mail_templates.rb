class CreateMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_templates do |t|
      t.string :name
      t.reference :recipient_list
      t.string :from_name
      t.string :from_mail_address
      t.string :subject_pre
      t.string :subject_post
      t.text :body_header
      t.text :body_footer
      t.integer :count
      t.time :reservation_time
      t.text :description

      t.timestamps
    end
  end
end
