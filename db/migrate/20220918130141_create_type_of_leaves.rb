class CreateTypeOfLeaves < ActiveRecord::Migration[5.2]
  def change
    create_table :type_of_leaves do |t|
      t.string :name
      t.string :status, :default => 'A'
      t.boolean :with_pay, :default => false
      t.timestamps
    end
  end
end
