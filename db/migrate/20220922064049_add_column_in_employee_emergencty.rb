class AddColumnInEmployeeEmergencty < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :emergency_contact_relationship, :string, :default => "" 
  end
end
