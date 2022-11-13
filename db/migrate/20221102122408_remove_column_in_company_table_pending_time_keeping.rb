class RemoveColumnInCompanyTablePendingTimeKeeping < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :pending_time_keeping
    add_column :companies, :max_vacation_leave_credit, :decimal, precision: 8, scale: 2, :default => 9.0
    add_column :companies, :max_sick_leave_credit, :decimal, precision: 8, scale: 2, :default => 9.0
  end
end
