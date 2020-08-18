class AddWrapToBulkMails < ActiveRecord::Migration[6.0]
  def change
    add_column :bulk_mails, :wrap_col, :integer, null: false, default: 0
    add_column :bulk_mails, :wrap_rule, :integer, null: false, default: 0
  end
end
