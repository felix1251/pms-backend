class AddColumnInCompanyAccountCode < ActiveRecord::Migration[5.2]
  def change
    add_column :company_accounts, :code, :string
  end
end
