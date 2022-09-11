class AddColumnToTimeKippings < ActiveRecord::Migration[5.2]
  def change
    add_column :time_keepings, :file_uid, :string, :default => ""
  end
end
