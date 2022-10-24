class AddEmployeeApproverOnCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :employee_approvers, :json
  end
end
