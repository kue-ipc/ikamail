class CreateManualLists < ActiveRecord::Migration[6.0]
  def change
    create_table :manual_lists do |t|
      t.belongs_to :recipient_list
      t.belongs_to :mail_user
      t.boolean :included
      t.boolean :excluded

      t.timestamps
    end
  end
end
