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

ActiveRecord::Schema.define(version: 2022_08_24_104849) do

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_companies_on_code"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
    t.index ["created_by_id"], name: "index_departments_on_created_by_id"
  end

  create_table "device_session_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "ip_address"
    t.text "os"
    t.string "device_name"
    t.bigint "user_id", null: false
    t.string "action"
    t.datetime "at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_device_session_records_on_user_id"
  end

  create_table "employee_action_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "action_by_id"
    t.bigint "employee_id"
    t.string "action_type"
    t.datetime "action_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_by_id"], name: "index_employee_action_histories_on_action_by_id"
    t.index ["employee_id"], name: "index_employee_action_histories_on_employee_id"
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "employee_id", null: false
    t.string "status", default: "A"
    t.string "biometric_no", default: ""
    t.string "first_name", null: false
    t.string "middle_name", null: false
    t.string "last_name", null: false
    t.string "suffix", default: ""
    t.bigint "position_id", null: false
    t.bigint "department_id"
    t.string "assigned_area", default: ""
    t.bigint "job_classification_id"
    t.bigint "salary_mode_id", null: false
    t.datetime "date_hired", null: false
    t.boolean "allow_ers_attendance", default: false
    t.datetime "date_regularized"
    t.datetime "date_resigned"
    t.bigint "employment_status_id", null: false
    t.string "sex", null: false
    t.datetime "birthdate", null: false
    t.string "work_sched_type", null: false
    t.string "work_sched_start"
    t.string "work_sched_end"
    t.string "work_sched_days"
    t.string "civil_status", default: ""
    t.string "phone_number", default: ""
    t.string "email", default: ""
    t.string "company_email", default: ""
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
    t.string "course", default: ""
    t.string "course_major", default: ""
    t.string "graduate_school", default: ""
    t.string "encrypted_compensation"
    t.string "encrypted_compensation_salt"
    t.string "encrypted_compensation_iv"
    t.string "emergency_contact_person", default: ""
    t.string "emergency_contact_number", default: ""
    t.text "remarks"
    t.text "others"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["created_by_id"], name: "index_employees_on_created_by_id"
    t.index ["date_hired"], name: "index_employees_on_date_hired"
    t.index ["date_resigned"], name: "index_employees_on_date_resigned"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["employee_id"], name: "index_employees_on_employee_id"
    t.index ["employment_status_id"], name: "index_employees_on_employment_status_id"
    t.index ["job_classification_id"], name: "index_employees_on_job_classification_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["salary_mode_id"], name: "index_employees_on_salary_mode_id"
    t.index ["sex"], name: "index_employees_on_sex"
  end

  create_table "employment_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_classifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_job_classifications_on_company_id"
    t.index ["created_by_id"], name: "index_job_classifications_on_created_by_id"
  end

  create_table "page_accesses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "page", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_page_accesses_on_access_code"
  end

  create_table "page_action_accesses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_page_action_accesses_on_access_code"
  end

  create_table "positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_positions_on_company_id"
    t.index ["created_by_id"], name: "index_positions_on_created_by_id"
  end

  create_table "salary_modes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "description"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_salary_modes_on_code"
  end

  create_table "session_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
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

  create_table "support_chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.text "encrypted_message"
    t.text "encrypted_message_iv"
    t.text "encrypted_message_salt"
    t.bigint "user_id_id"
    t.bigint "admin_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id_id"], name: "index_support_chats_on_admin_id_id"
    t.index ["user_id_id"], name: "index_support_chats_on_user_id_id"
  end

  create_table "user_page_action_accesses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "page_access_id", null: false
    t.bigint "page_action_access_id", null: false
    t.string "status", default: "I", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_access_id"], name: "index_user_page_action_accesses_on_page_access_id"
    t.index ["page_action_access_id"], name: "index_user_page_action_accesses_on_page_action_access_id"
    t.index ["user_id"], name: "index_user_page_action_accesses_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
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
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "departments", "users", column: "created_by_id"
  add_foreign_key "employee_action_histories", "users", column: "action_by_id"
  add_foreign_key "employees", "users", column: "created_by_id"
  add_foreign_key "job_classifications", "companies"
  add_foreign_key "job_classifications", "users", column: "created_by_id"
  add_foreign_key "positions", "companies"
  add_foreign_key "positions", "users", column: "created_by_id"
  add_foreign_key "users", "companies"
end
