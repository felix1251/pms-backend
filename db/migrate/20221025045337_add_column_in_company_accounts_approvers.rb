class AddColumnInCompanyAccountsApprovers < ActiveRecord::Migration[5.2]
  def change
    add_column :company_accounts, :approvers, :json
  end
end
