class CreatePayrolls < ActiveRecord::Migration[5.2]
  def change
    create_table :payrolls do |t|
      t.date :from, null: false, index: true
      t.date :to, null: false, index: true
      t.references :company, foreign_key: true, null: false
      t.references :approver, foreign_key: { to_table: 'users' }
      t.boolean :require_approver, default: false
      t.string :string, :default => "P", :limit => 1
      t.timestamps
    end
  end
end
