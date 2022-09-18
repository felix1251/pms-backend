class AddColumnToCompensationHistories < ActiveRecord::Migration[5.2]
  def change
      add_column :compensation_histories, :compensation, :integer, :null => false
  end
end
