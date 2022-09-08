class CreateFailedTimeKeepings < ActiveRecord::Migration[5.2]
  def change
    create_table :failed_time_keepings do |t|
      t.text :details
      t.integer :emp_bio_no
      t.references :company
      t.timestamps
    end
  end
end
