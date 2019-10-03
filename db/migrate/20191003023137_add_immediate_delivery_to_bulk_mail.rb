class AddImmediateDeliveryToBulkMail < ActiveRecord::Migration[6.0]
  def change
    add_column :bulk_mails, :immediate_delivery, :boolean, null: false
  end
end
