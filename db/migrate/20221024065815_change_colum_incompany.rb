class ChangeColumIncompany < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :page_accesses, :json
  end
end
