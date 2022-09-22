class AddColumnToEmployeeLeaveCredit < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :leave_credit, :decimal, null: false, :precision => 8, :scale => 2, :default => 10.0
  end
end
