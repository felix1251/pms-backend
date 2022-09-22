class RenameColumnString < ActiveRecord::Migration[5.2]
  def change
    rename_column :payrolls, :string, :status
  end
end
