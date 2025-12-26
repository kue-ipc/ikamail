# frozen_string_literal: true

class AddDeviseLockableToUsers < ActiveRecord::Migration[8.1]
  def change
    ## Lockable
    # Only if lock strategy is :failed_attempts
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    # Only if unlock strategy is :email or :both
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    add_index :users, :unlock_token, unique: true
  end
end
