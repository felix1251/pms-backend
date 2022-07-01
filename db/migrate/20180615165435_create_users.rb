class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: '', null: false
      t.string :password_digest
      t.string :position, default: "HR-staff"
      t.string :name, default: ''
      t.boolean :hr_head, default: false
      t.string :username, null: false, length: {minimum: 5, maximum: 20}, unique: true
      t.string :status, default: 'A'
      t.text :page_access_rigths, default: "[\"D\", \"R\", \"T\", \"S\", \"V\"]"
      t.text :action_access_rigths, default: "[\"A\", \"D\", \"E\", \"X\"]"
      t.timestamps
    end
  end
end
