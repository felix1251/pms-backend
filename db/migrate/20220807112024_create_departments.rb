class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.references :company, index: true, null: false
      t.string :name, null: false
      t.string :code, null: false
      t.references :created_by, foreign_key: { to_table: 'users' }
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
