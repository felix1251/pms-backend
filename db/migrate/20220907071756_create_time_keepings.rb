class CreateTimeKeepings < ActiveRecord::Migration[5.2]
  def change
    create_table :time_keepings do |t|
      t.integer :biometric_no, null: false
      t.datetime :date, null: false
      t.integer :status, null: false
      t.integer :verified, null: false, :default => 1
      t.integer :work_code, null: false, :default => 0
      t.integer :record_type, null: false, :default => 1
      t.integer :device_id, null: false
      t.references :company, null: false

      t.timestamps
    end
  end
end
