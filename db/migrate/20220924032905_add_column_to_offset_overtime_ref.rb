class AddColumnToOffsetOvertimeRef < ActiveRecord::Migration[5.2]
  def change
    add_reference :offsets, :overtime , foreign_key: true
  end
end
