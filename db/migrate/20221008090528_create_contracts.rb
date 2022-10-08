class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.references :company, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :remarks

      t.timestamps
    end
  end
end
