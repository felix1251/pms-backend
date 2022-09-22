class CreateCompensationHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :compensation_histories do |t|
      t.references :employee
      t.string :description

      t.timestamps
    end
  end
end
