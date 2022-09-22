class AddColumnObCompanyId < ActiveRecord::Migration[5.2]
  def change
    add_reference :official_businesses, :company, foreign_key: true
  end
end
