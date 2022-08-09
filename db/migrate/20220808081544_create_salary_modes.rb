class CreateSalaryModes < ActiveRecord::Migration[5.2]
  def change
    create_table :salary_modes do |t|
      t.string :description
      t.string :code, index: true
      t.timestamps
    end
  end
end
