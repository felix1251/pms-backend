class AddColumnInLeaveOrigin < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :origin, :integer, :default => 0, :limit => 1
  end
end
