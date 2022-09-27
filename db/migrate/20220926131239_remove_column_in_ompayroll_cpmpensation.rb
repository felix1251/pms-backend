class RemoveColumnInOmpayrollCpmpensation < ActiveRecord::Migration[5.2]
  def change
    remove_column :on_payroll_compensations, :position_id_id
  end
end
