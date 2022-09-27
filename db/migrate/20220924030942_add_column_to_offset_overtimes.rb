class AddColumnToOffsetOvertimes < ActiveRecord::Migration[5.2]
  def change
    add_reference :offset_overtimes, :offset , foreign_key: true
  end
end
