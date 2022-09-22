class AddColumnInLeaveReferenceCoulumn < ActiveRecord::Migration[5.2]
  def change
    add_reference :leaves, :company, foreign_key: true
  end
end
