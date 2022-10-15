class CreateEmployeeAllowances < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_allowances do |t|
      t.references :employee, foreign_key: true, null: false
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
