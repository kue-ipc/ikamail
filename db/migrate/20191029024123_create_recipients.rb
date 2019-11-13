# frozen_string_literal: true

class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.belongs_to :recipient_list, null: false, foreign_key: true
      t.belongs_to :mail_user, null: false, foreign_key: true
      t.boolean :included, null: false, default: false
      t.boolean :excluded, null: false, default: false

      t.timestamps
    end
  end
end
