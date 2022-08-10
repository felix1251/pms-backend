class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.references :company, index: true, null: false
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps
    end
  end
end
