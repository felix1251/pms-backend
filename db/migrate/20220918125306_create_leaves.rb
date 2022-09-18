class CreateLeaves < ActiveRecord::Migration[5.2]
  def change
    create_table :leaves do |t|
      t.date :start_date
      t.date :end_date
      t.string :leave_type
      t.text :reason
      t.string :status, :default => 'P', :limit => 1
      t.references :approve_by, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
