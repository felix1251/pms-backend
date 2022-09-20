class RenameColumnInLeaves < ActiveRecord::Migration[5.2]
  def change
    rename_column :leaves, :approve_by_id, :actioned_by_id
  end
end
