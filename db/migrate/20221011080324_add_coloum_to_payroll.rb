class AddColoumToPayroll < ActiveRecord::Migration[5.2]
  def change
    add_reference :payrolls, :sss_contribution, foreign_key: true
  end
end
