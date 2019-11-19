class AddReservedAtToBulkMails < ActiveRecord::Migration[6.0]
  def change
    add_column :bulk_mails, :reserved_at, :datetime
  end
end
