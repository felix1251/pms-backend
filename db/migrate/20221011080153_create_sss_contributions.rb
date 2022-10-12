class CreateSssContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :sss_contributions do |t|
      t.string :title, null: false
      t.string :status, :default => "I", :length => 1, null: false

      t.timestamps
    end
  end
end
