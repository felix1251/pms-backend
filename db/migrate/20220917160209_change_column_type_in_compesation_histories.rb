class ChangeColumnTypeInCompesationHistories < ActiveRecord::Migration[5.2]
  def change
    change_column :compensation_histories, :compensation, :decimal, :precision => 8, :scale => 2
  end
end
