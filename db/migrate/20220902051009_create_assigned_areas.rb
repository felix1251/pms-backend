class CreateAssignedAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :assigned_areas do |t|
      t.references :company, foreign_key: true
      t.string :name
      t.string :code
      t.references :created_by, foreign_key: { to_table: 'users' }
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
