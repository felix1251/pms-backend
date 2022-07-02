class CreateUserPageAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :user_page_accesses do |t|
      t.references :user, null: false
      t.references :page_access, null: false
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
