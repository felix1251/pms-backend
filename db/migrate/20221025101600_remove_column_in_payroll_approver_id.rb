class RemoveColumnInPayrollApproverId < ActiveRecord::Migration[5.2]
  def change
    remove_reference :payrolls, :approver, index: true, foreign_key: { to_table: 'users' }
  end
end
