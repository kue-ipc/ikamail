# frozen_string_literal: true

class CreateMailUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_users do |t|
      t.string :mail, null: false
      t.string :name, null: false
      t.string :display_name

      t.timestamps
    end
    add_index :mail_users, :mail, unique: true
    add_index :mail_users, :name, unique: true
  end
end
