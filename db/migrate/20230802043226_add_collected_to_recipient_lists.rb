class AddCollectedToRecipientLists < ActiveRecord::Migration[7.0]
  def change
    add_column :recipient_lists, :collected, :boolean, null: false, default: false
  end
end
