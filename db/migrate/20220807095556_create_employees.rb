class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.references :company, null: false, index: true
      t.string :status, :default => "A"
      t.string :biometric_no, :default => ""
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :last_name, null: false
      t.string :suffix, :default => ""
      t.string :position, null: false
      t.references :department, index: true
      t.string :assigned_area, :default => ""
      t.string :job_classification, null: false, index: true
      t.references :salary_mode, null: false, index: true
      t.datetime :date_hired, null: false, index: true
      t.datetime :date_resigned, :default => ""
      t.string :employment_status, null: false, index: true
      t.string :sex, null: false, index: true
      t.string :birthdate, null: false
      t.integer :age, null: false
      t.string :phone_number, null: false, :default => ""
      t.string :email, :default => ""
      t.string :street, :null => false
      t.string :barangay, :null => false
      t.string :municipality, :null => false
      t.string :province, :null => false
      t.string :sss_no, null: false
      t.string :hdmf_no, null: false
      t.string :tin_no, null: false
      t.string :phic_no, null: false
      t.string :highest_educational_attainment, null: false
      t.string :institution, null: false
      t.text :course, :default => ""
      t.string :graduate_school, :default => ""
      t.integer :employee_compensation, null: false
      t.timestamps
    end
  end
end
