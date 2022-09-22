class AddColumnOnPayrollCompensation < ActiveRecord::Migration[5.2]
  def change
    add_reference :on_payroll_compensations, :company_account , foreign_key: true
  end
end
