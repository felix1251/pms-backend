class AddColumnToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :worker_pid_list, :string
  end
end
