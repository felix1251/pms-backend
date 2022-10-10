class CreatePagibigs < ActiveRecord::Migration[5.2]
  def change
    create_table :pagibigs do |t|
      t.decimal :amount, :precision => 8, :scale => 2, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
