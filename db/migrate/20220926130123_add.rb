class Add < ActiveRecord::Migration[5.2]
  def change
    add_reference :on_payroll_compensations, :position, foreign_key: true
    add_reference :on_payroll_compensations, :department, foreign_key: true
    add_reference :on_payroll_compensations, :salary_mode, foreign_key: true
  end
end
