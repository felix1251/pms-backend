class CreatePmsDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :pms_devices do |t|
      t.references :company, foreign_key: true, null: false
      t.string :device_id, null: false
      t.string :device_name, null: false
      t.boolean :allowed, :default => true
      t.timestamps
    end
  end
end
