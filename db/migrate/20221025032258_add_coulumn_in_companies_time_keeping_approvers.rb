class AddCoulumnInCompaniesTimeKeepingApprovers < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :time_keeping_approvers, :json
  end
end
