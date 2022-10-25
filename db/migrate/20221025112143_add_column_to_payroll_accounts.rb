class AddColumnToPayrollAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :payroll_accounts, :approved, :boolean, :default => false
    add_reference :payroll_accounts, :approved_by, foreign_key: { to_table: 'users' }
  end
end
