class CreateOvertimes < ActiveRecord::Migration[5.2]
  def change
    create_table :overtimes do |t|
      t.references :employee, foreign_key: true
      t.references :company, foreign_key: true
      t.integer :origin, :default => 0
      t.text :output
      t.datetime :start_date
      t.datetime :end_date
      t.references :actioned_by, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
