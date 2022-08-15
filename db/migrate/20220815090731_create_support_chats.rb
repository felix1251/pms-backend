class CreateSupportChats < ActiveRecord::Migration[5.2]
  def change
    create_table :support_chats do |t|
      t.text :encrypted_message
      t.text :encrypted_message_iv
      t.text :encrypted_message_salt
      t.references :user_id
      t.references :admin_id
      t.timestamps
    end
  end
end
