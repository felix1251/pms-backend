class RenameColoumInOnPayrollAadjusmtnets < ActiveRecord::Migration[5.2]
  def change
    rename_column :on_payroll_adjustments, :type, :adjustment_type
  end
end
