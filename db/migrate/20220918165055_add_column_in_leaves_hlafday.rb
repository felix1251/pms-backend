class AddColumnInLeavesHlafday < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :half_day, :boolean, :default => false
  end
end
