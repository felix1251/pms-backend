class CreateOffsetOvertimes < ActiveRecord::Migration[5.2]
  def change
    create_table :offset_overtimes do |t|
      t.references :overtime, foreign_key: true
      t.timestamps
    end
  end
end
