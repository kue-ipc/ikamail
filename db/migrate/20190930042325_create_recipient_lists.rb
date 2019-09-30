class CreateRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :recipient_lists do |t|
      t.string :name
      t.string :display_name
      t.text :description

      t.timestamps
    end
  end
end
