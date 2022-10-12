class AddColumnToPayrollPhisRef < ActiveRecord::Migration[5.2]
  def change
    add_reference :payrolls, :philhealth, foreign_key: true
  end
end
