class CreateOnPayrollAllowances < ActiveRecord::Migration[5.2]
  def change
    create_table :on_payroll_allowances do |t|
      t.references :employee, foreign_key: true, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.text :name, null: false
      t.references :payroll, foreign_key: true, null: false
      t.timestamps
    end
  end
end
