class AddColumnInTypeOfLeavesCode < ActiveRecord::Migration[5.2]
  def change
    add_column :type_of_leaves, :code, :string, :null => false
  end
end
