class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: '', null: false
      t.string :password_digest
      t.string :fullname, null: false
      t.boolean :status, default: true
      t.text :page_access_rigths, default: "[\"D\", \"R\", \"T\", \"S\", \"V\"]"
      t.text :action_access_rigths, default: "[\"A\", \"D\", \"E\", \"X\"]"
      t.timestamps
    end
  end
end
