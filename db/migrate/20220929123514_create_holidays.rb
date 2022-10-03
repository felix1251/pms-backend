class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :type_of_holiday, length: 1, null: false
      t.date :date, null: false
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
