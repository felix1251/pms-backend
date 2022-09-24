class RemoveColumnToOffsetOvertimeRef < ActiveRecord::Migration[5.2]
  def change
    remove_reference :offsets, :overtime, index: true, foreign_key: true
  end
end
