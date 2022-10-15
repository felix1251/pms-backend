class CreateOnPayrollAdjustments < ActiveRecord::Migration[5.2]
  def change
    create_table :on_payroll_adjustments do |t|
      t.references :payroll, foreign_key: true, null: false
      t.references :employee, foreign_key: true, null: false
      t.string :description, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :type, null: false, :length => 1
      t.timestamps
    end
  end
end
