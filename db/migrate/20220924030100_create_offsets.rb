class CreateOffsets < ActiveRecord::Migration[5.2]
  def change
    create_table :offsets do |t|
      t.references :company, foreign_key: true
      t.references :employee, foreign_key: true
      t.date :offset_date
      t.integer :origin, :default => 0
      t.text :reason
      t.references :actioned_by, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
