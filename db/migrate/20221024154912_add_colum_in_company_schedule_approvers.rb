class AddColumInCompanyScheduleApprovers < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :schedule_approvers, :json
  end
end
