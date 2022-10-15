class ChangeColumnEmployeeAllowancesColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :employee_allowances, :amount, :decimal, precision: 8, scale: 2
  end
end
