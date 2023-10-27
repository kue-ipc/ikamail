class AddReservationNumberToBulkMails < ActiveRecord::Migration[7.0]
  def change
    add_column :bulk_mails, :reservation_number, :integer
  end
end
