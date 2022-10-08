class AddStatusColInCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :status, :string, :length => 1, default: "A"
  end
end
