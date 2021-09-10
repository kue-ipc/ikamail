# rubocop: disable Rails/CreateTableWithTimestamps
class CreateMailGroupsRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_groups_recipient_lists do |t|
      t.belongs_to :mail_group, null: false, foreign_key: true
      t.belongs_to :recipient_list, null: false, foreign_key: true
    end
  end
end
# rubocop: enable Rails/CreateTableWithTimestamps
