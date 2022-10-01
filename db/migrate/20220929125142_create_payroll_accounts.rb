class CreatePayrollAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :payroll_accounts do |t|
      t.references :payroll, foreign_key: true
      t.references :company_account, foreign_key: true

      t.timestamps
    end
  end
end
