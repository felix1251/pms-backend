class AddColumnToEmployeeAllowances < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_allowances, :name, :string, :null => false
  end
end
