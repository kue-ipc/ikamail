# frozen_string_literal: true

class CreateRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :recipient_lists do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :recipient_lists, :name, unique: true
  end
end
