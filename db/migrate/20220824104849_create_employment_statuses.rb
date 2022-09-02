class CreateEmploymentStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :employment_statuses do |t|
      t.string :name
      t.string :code
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
