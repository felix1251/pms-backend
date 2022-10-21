class AddColumnToEmployeeProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :profile, :string
  end
end
