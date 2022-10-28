class AddcolumnInPageAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :page_accesses, :position, :integer, :null => false
  end
end
