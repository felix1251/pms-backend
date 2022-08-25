class CreateEmployeeActionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_action_histories do |t|
      t.references :action_by, foreign_key: { to_table: 'users' }
      t.references :employee
      t.string :action_type
      t.datetime :action_at
      t.timestamps
    end
  end
end
