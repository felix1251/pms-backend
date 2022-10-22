class AddColumnInUserPageAccesses < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :page_accesses, :text
  end
end
