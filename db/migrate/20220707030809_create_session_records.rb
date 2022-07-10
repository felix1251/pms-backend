class CreateSessionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :session_records do |t|
      t.references :user, null: false
      t.datetime :first_logged_in
      t.datetime :previous_logged_in
      t.datetime :recent_logged_in
      t.string :status, default: "I"
      t.timestamps
    end
  end
end
