class CreatePhilhealths < ActiveRecord::Migration[5.2]
  def change
    create_table :philhealths do |t|
      t.decimal :percentage_deduction, :precision => 8, :scale => 2, null: false
      t.string :title, null: false
      t.timestamps
    end
  end
end
