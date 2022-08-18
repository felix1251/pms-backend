class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.references :company, null: false, index: true
      t.string :employee_id, null: false, index: true
      t.string :status, :default => "A"
      t.string :biometric_no, :default => ""
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :last_name, null: false
      t.string :suffix, :default => ""
      t.string :position, null: false
      t.references :department, index: true
      t.string :assigned_area, :default => ""
      t.string :job_classification, :default => "", index: true
      t.references :salary_mode, null: false, index: true
      t.date :date_hired, null: false, index: true
      t.boolean :allow_ers_attendance, :default => false
      t.date :date_regularized
      t.date :date_resigned, index: true
      t.string :employment_status, null: false, index: true
      t.string :sex, null: false, index: true
      t.date :birthdate, null: false
      t.string :civil_status, :default => ""
      t.string :phone_number, :default => ""
      t.string :email, :default => ""
      t.string :street, :null => false
      t.string :barangay, :null => false
      t.string :municipality, :null => false
      t.string :province, :null => false
      t.string :sss_no, :default => ""
      t.string :hdmf_no, :default => ""
      t.string :tin_no, :default => ""
      t.string :phic_no, :default => ""
      t.string :highest_educational_attainment, null: false
      t.string :institution, :default => ""
      t.string :course, :default => ""
      t.string :course_major, :default => ""
      t.string :graduate_school, :default => ""
      t.string :encrypted_compensation
      t.string :encrypted_compensation_salt
      t.string :encrypted_compensation_iv
      t.string :emergency_contact_person, :default => ""
      t.string :emergency_contact_number, :default => ""
      t.text :remarks
      t.text :others
      t.timestamps
    end
  end
end
