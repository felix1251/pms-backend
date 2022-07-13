class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :code, null: false, length: {minimum: 3, maximum: 15}, unique: true, index: true
      t.text :description, null: false
      t.timestamps
    end
  end
end
