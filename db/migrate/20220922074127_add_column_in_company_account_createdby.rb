class AddColumnInCompanyAccountCreatedby < ActiveRecord::Migration[5.2]
  def change
    add_reference :company_accounts, :created_by, foreign_key:  { to_table: 'users' }
  end
end
