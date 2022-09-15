class AddColumnToPayrollTable < ActiveRecord::Migration[5.2]
  def change
    add_column :payrolls, :remarks, :text
  end
end
