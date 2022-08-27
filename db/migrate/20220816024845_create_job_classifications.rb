class CreateJobClassifications < ActiveRecord::Migration[5.2]
  def change
    create_table :job_classifications do |t|
      t.references :company, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false
      t.references :created_by, foreign_key: { to_table: 'users' }
      t.string :status, :default => "A"
      t.timestamps
    end
  end
end
