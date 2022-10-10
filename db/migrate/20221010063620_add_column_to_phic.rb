class AddColumnToPhic < ActiveRecord::Migration[5.2]
  def change
    add_column :philhealths, :status, :string, :default => "I", :length => 1
  end
end
