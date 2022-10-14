class CreatePayrollComments < ActiveRecord::Migration[5.2]
  def change
    create_table :payroll_comments do |t|
      t.references :payroll, foreign_key: true, null: false
      t.string :type, :default => "text"
      t.text :comment, null: false
      t.references :user, foreign_key: true, null: false
      t.datetime :time_sent, null: false

      t.timestamps
    end
  end
end
