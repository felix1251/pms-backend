class AddColumnToPayroll < ActiveRecord::Migration[5.2]
  def change
    add_reference :payrolls, :pagibig, foreign_key: true
  end
end
