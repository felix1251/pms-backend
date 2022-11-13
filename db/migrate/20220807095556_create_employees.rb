class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.references :company, null: false, index: true
      t.string :employee_id, null: false, index: true
      t.string :status, :default => "A"
      t.integer :biometric_no
      t.string :first_name, null: false
      t.string :middle_name, :default => ""
      t.string :last_name, null: false
      t.string :suffix, :default => ""
      t.references :position, null: false, index: true
      t.references :department, index: true
      t.references :assigned_area, index: true
      t.references :job_classification, index: true
      t.references :salary_mode, null: false, index: true
      t.datetime :date_hired, null: false, index: true
      t.boolean :allow_ers_attendance, :default => false
      t.datetime :date_regularized
      t.datetime :date_resigned, index: true
      t.references :employment_status, null: false
      t.string :sex, null: false, index: true
      t.datetime :birthdate, null: false
      t.string :work_sched_type, null: false
      t.string :work_sched_start, :length => 5
      t.string :work_sched_end, :length => 5
      t.json :work_sched_days
      t.string :civil_status, :default => ""
      t.string :phone_number, :default => ""
      t.string :email, :default => ""
      t.string :company_email, :default => ""
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
      t.decimal :compensation, :precision => 8, :scale => 2, null: false
      t.string :emergency_contact_person, :default => ""
      t.string :emergency_contact_number, :default => ""
      t.text :remarks
      t.text :others
      t.references :created_by, foreign_key: { to_table: 'users' }, null: false
      t.timestamps
    end
  end
end
