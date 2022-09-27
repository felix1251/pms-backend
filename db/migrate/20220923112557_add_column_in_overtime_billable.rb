class AddColumnInOvertimeBillable < ActiveRecord::Migration[5.2]
  def change
    add_column :overtimes, :billable, :boolean, :default => true
  end
end
