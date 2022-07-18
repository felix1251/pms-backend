class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: '', null: false
      t.string :password_digest
      t.string :position, default: "HR-staff"
      t.string :name, default: ''
      t.boolean :admin, default: false
      t.string :username, null: false, length: {minimum: 5, maximum: 20}, unique: true, index: true
      t.string :status, default: 'A'
      t.boolean :system_default, default: false
      t.timestamps
    end
  end
end
