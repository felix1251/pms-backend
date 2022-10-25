class RemoveColumnInPayrollRequireApprover < ActiveRecord::Migration[5.2]
  def change
    remove_column :payrolls, :require_approver
  end
end
