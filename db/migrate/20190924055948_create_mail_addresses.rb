class CreateMailAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_addresses do |t|
      t.string :address
      t.string :name
      t.string :display_name

      t.timestamps
    end
    add_index :mail_addresses, :address, unique: true
    add_index :mail_addresses, :name
  end
end
