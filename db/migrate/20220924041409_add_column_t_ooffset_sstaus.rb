class AddColumnTOoffsetSstaus < ActiveRecord::Migration[5.2]
  def change
    add_column :offsets, :status, :string, :default => 'P'
  end
end
