class CreateSessionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :session_records do |t|
      t.references :user, null: false
      t.datetime :first_logged_in
      t.datetime :previous_logged_in
      t.datetime :recent_logged_in
      t.string :status, default: "I"
      t.integer :sign_in_count, default: 0
      t.string :current_device, default: ""
      t.string :current_device_id, null: false
      t.string :current_os, default: ""
      t.string :current_ip_address, default: ""
      t.timestamps
    end
  end
end
