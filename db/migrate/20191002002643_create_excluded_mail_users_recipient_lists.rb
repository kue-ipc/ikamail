class CreateExcludedMailUsersRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :excluded_mail_users_recipient_lists do |t|
      t.belongs_to :mail_user
      t.belongs_to :recipient_list
    end
  end
end
