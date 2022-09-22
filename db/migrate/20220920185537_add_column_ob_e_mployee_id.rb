class AddColumnObEMployeeId < ActiveRecord::Migration[5.2]
  def change
    add_reference :official_businesses, :employee, foreign_key: true
  end
end
