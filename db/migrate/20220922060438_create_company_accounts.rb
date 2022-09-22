class CreateCompanyAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :company_accounts do |t|
      t.string :name
      t.references :company, foreign_key: true
      t.string :status, :default => 'A', :limit => 1 
      t.timestamps
    end
  end
end
