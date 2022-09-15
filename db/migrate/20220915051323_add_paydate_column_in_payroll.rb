class AddPaydateColumnInPayroll < ActiveRecord::Migration[5.2]
  def change
    add_column :payrolls, :pay_date, :date
  end
end
