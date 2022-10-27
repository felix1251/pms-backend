class AddColumnInCompaniesEmployeeRequestApprovers < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :request_administrative_approvers, :json
    add_column :companies, :request_supervisory_approvers, :json
  end
end
