class AddColumnInEmployeeCompanyAccountId < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :company_account, foreign_key: true
  end
end
