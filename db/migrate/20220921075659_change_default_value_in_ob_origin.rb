class ChangeDefaultValueInObOrigin < ActiveRecord::Migration[5.2]
  def change
    change_column_default :official_businesses, :origin, 0
  end
end
