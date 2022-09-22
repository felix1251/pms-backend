class CreateOnPayrollCompensations < ActiveRecord::Migration[5.2]
  def change
    create_table :on_payroll_compensations do |t|
      t.references :employee, foreign_key: true
      t.decimal :compesation, :precision => 8, :scale => 2
      t.references :payroll, foreign_key: true

      t.timestamps
    end
  end
end
