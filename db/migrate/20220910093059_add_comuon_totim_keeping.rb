class AddComuonTotimKeeping < ActiveRecord::Migration[5.2]
  def change
    add_column :time_keepings, :from_file, :string, :default => ""
  end
end
