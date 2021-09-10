class CreateMailMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_memberships do |t|
      t.belongs_to :mail_user, null: false, foreign_key: true
      t.belongs_to :mail_group, null: false, foreign_key: true
      t.boolean :primary, null: false

      t.timestamps
    end
  end
end
