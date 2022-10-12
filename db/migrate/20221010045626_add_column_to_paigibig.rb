class AddColumnToPaigibig < ActiveRecord::Migration[5.2]
  def change
    add_column :pagibigs, :status, :string, :default => "I", :length => 1
  end
end
