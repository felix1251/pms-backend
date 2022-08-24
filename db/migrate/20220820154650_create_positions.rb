class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.references :company, foreign_key: true
      t.string :name
      t.string :code
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
