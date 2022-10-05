class AddColumnToHolidaysTitle < ActiveRecord::Migration[5.2]
  def change
    add_column :holidays, :title, :string, :null => false
  end
end
