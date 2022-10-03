class AddCOlumnToEmployeeShecId < ActiveRecord::Migration[5.2]
  def change
    add_reference :employee_schedules, :schedule, foreign_key: true
  end
end
