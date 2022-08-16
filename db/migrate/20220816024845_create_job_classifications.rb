class CreateJobClassifications < ActiveRecord::Migration[5.2]
  def change
    create_table :job_classifications do |t|
      t.references :company_id, foreign_key: true
      t.string :description, null: false
      t.references :created_by, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
