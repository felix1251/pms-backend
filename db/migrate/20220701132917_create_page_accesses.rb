class CreatePageAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :page_accesses do |t|
      t.string :access_code, null: false, :length => 1
      t.string :page, null: false, :default => "I"
      t.timestamps
    end
  end
end
