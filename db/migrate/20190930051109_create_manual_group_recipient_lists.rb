class CreateManualGroupRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :manual_group_recipient_lists do |t|
      t.belongs_to :mail_group
      t.belongs_to :recipient_list
    end
  end
end
