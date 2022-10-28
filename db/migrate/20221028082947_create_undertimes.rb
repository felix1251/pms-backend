class CreateUndertimes < ActiveRecord::Migration[5.2]
  def change
    create_table :undertimes do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :status, :default => 'P'
      t.references :company, foreign_key: true
      t.references :employee, foreign_key: true
      t.integer :origin, :default => 0
      t.text :reason
      t.references :actioned_by, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
