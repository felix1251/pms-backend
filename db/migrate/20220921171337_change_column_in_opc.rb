class ChangeColumnInOpc < ActiveRecord::Migration[5.2]
  def change
    rename_column :on_payroll_compensations, :compesation, :compensation
  end
end
