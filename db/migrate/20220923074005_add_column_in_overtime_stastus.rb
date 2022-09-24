class AddColumnInOvertimeStastus < ActiveRecord::Migration[5.2]
  def change
    add_column :overtimes, :status, :string, :default => 'P'
  end
end
