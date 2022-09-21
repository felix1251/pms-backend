class CreateOfficialBusinesses < ActiveRecord::Migration[5.2]
  def change
    create_table :official_businesses do |t|
      t.date :start_date
      t.date :end_date
      t.string :client
      t.text :reason
      t.string :status, :default => 'P', :limit => 1
      t.references :actioned_by, foreign_key: { to_table: 'users' }
      t.integer :origin

      t.timestamps
    end
  end
end
