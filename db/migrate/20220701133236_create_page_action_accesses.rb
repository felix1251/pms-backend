class CreatePageActionAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :page_action_accesses do |t|
      t.string :access_code, null: false
      t.string :action, null: false, :default => "I"
      t.timestamps
    end
  end
end
