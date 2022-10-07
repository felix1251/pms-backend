class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :username,  length: {minimum: 5, maximum: 30}, unique: true, index: true
      t.string :password_digest
      t.string :status, default: 'A', length: 1
      t.string :name

      t.timestamps
    end
  end
end
