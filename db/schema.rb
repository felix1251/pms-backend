# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_16_024845) do

  create_table "companies", force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_companies_on_code"
  end

  create_table "departments", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "device_session_records", force: :cascade do |t|
    t.string "ip_address"
    t.text "os"
    t.string "device_name"
    t.integer "user_id", null: false
    t.string "action"
    t.datetime "at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_device_session_records_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "employee_id", null: false
    t.string "status", default: "A"
    t.string "biometric_no", default: ""
    t.string "first_name", null: false
    t.string "middle_name", null: false
    t.string "last_name", null: false
    t.string "suffix", default: ""
    t.string "position", null: false
    t.integer "department_id"
    t.string "assigned_area", default: ""
    t.string "job_classification", default: ""
    t.integer "salary_mode_id", null: false
    t.date "date_hired", null: false
    t.date "date_regularized"
    t.date "date_resigned"
    t.string "employment_status", null: false
    t.string "sex", null: false
    t.date "birthdate", null: false
    t.string "civil_status", default: ""
    t.string "phone_number", default: ""
    t.string "email", default: ""
    t.string "street", null: false
    t.string "barangay", null: false
    t.string "municipality", null: false
    t.string "province", null: false
    t.string "sss_no", default: ""
    t.string "hdmf_no", default: ""
    t.string "tin_no", default: ""
    t.string "phic_no", default: ""
    t.string "highest_educational_attainment", null: false
    t.string "institution", default: ""
    t.text "course", default: ""
    t.text "course_major", default: ""
    t.string "graduate_school", default: ""
    t.string "encrypted_compensation"
    t.string "encrypted_compensation_salt"
    t.string "encrypted_compensation_iv"
    t.string "emergency_contact_person", default: ""
    t.string "emergency_contact_number", default: ""
    t.text "remarks", default: ""
    t.text "others", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["date_hired"], name: "index_employees_on_date_hired"
    t.index ["date_resigned"], name: "index_employees_on_date_resigned"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["employee_id"], name: "index_employees_on_employee_id"
    t.index ["employment_status"], name: "index_employees_on_employment_status"
    t.index ["job_classification"], name: "index_employees_on_job_classification"
    t.index ["salary_mode_id"], name: "index_employees_on_salary_mode_id"
    t.index ["sex"], name: "index_employees_on_sex"
  end

  create_table "job_classifications", force: :cascade do |t|
    t.integer "company_id_id"
    t.string "description", null: false
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id_id"], name: "index_job_classifications_on_company_id_id"
    t.index ["created_by_id"], name: "index_job_classifications_on_created_by_id"
  end

  create_table "page_accesses", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "page", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_page_accesses_on_access_code"
  end

  create_table "page_action_accesses", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_page_action_accesses_on_access_code"
  end

  create_table "salary_modes", force: :cascade do |t|
    t.string "description"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_salary_modes_on_code"
  end

  create_table "session_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "first_logged_in"
    t.datetime "previous_logged_in"
    t.datetime "recent_logged_in"
    t.string "status", default: "I"
    t.integer "sign_in_count", default: 0
    t.string "current_device", default: ""
    t.string "current_os", default: ""
    t.string "current_ip_address", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_session_records_on_user_id"
  end

  create_table "support_chats", force: :cascade do |t|
    t.text "encrypted_message"
    t.text "encrypted_message_iv"
    t.text "encrypted_message_salt"
    t.integer "user_id_id"
    t.integer "admin_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id_id"], name: "index_support_chats_on_admin_id_id"
    t.index ["user_id_id"], name: "index_support_chats_on_user_id_id"
  end

  create_table "user_page_action_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "page_access_id", null: false
    t.integer "page_action_access_id", null: false
    t.string "status", default: "I", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_access_id"], name: "index_user_page_action_accesses_on_page_access_id"
    t.index ["page_action_access_id"], name: "index_user_page_action_accesses_on_page_action_access_id"
    t.index ["user_id"], name: "index_user_page_action_accesses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "password_digest"
    t.string "position", default: "HR-staff"
    t.string "name", default: ""
    t.boolean "admin", default: false
    t.string "username", null: false
    t.string "status", default: "A"
    t.boolean "system_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["username"], name: "index_users_on_username"
  end

end
