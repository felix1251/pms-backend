class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: '', null: false
      t.string :password_digest
      t.string :fullname, null: false
      t.boolean :status, default: true
      t.references :college, null: true, foreign_key: true, :on_delete => :cascade
      t.references :curriculum, null: true, foreign_key: true, :on_delete => :cascade
  
      t.timestamps
    end
  end
end
