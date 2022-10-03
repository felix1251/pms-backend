class AddColumnInScheduleDepartmentId < ActiveRecord::Migration[5.2]
  def change
    add_reference :schedules, :department, foreign_key: true
  end
end
