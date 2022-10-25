class ChangeColoumnInEmployees < ActiveRecord::Migration[5.2]
  def change
    change_column :employees, :work_sched_days, :json
  end
end
