class CreateDeviceSessionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :device_session_records do |t|
      t.string :ip_address
      t.text :os
      t.string :device_name
      t.references :user, null: false
      t.string :action
      t.timestamps
    end
  end
end
