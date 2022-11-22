class AddColumnToEmployeeSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :employee_schedules, :duty_type, :string, :default => "X"
  end
end
