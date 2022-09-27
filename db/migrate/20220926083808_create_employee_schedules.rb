class CreateEmployeeSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
