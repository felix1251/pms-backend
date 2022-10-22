class AddSeetingColumnInCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :settings, :json
  end
end