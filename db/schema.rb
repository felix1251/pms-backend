# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_02_124940) do
  create_table "administrators", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "status", default: "A"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["username"], name: "index_administrators_on_username"
  end

  create_table "assigned_areas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.string "code"
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_assigned_areas_on_company_id"
    t.index ["created_by_id"], name: "index_assigned_areas_on_created_by_id"
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "A"
    t.json "worker_pid_list"
    t.string "logo"
    t.json "settings"
    t.json "employee_approvers"
    t.json "schedule_approvers"
    t.json "time_keeping_approvers"
    t.json "request_administrative_approvers"
    t.json "request_supervisory_approvers"
    t.decimal "max_vacation_leave_credit", precision: 8, scale: 2, default: "9.0"
    t.decimal "max_sick_leave_credit", precision: 8, scale: 2, default: "9.0"
    t.index ["code"], name: "index_companies_on_code"
  end

  create_table "company_accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.string "status", limit: 1, default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "code"
    t.bigint "created_by_id"
    t.json "approvers"
    t.index ["company_id"], name: "index_company_accounts_on_company_id"
    t.index ["created_by_id"], name: "index_company_accounts_on_created_by_id"
  end

  create_table "compensation_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "compensation", precision: 8, scale: 2, null: false
    t.index ["employee_id"], name: "index_compensation_histories_on_employee_id"
  end

  create_table "contracts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "remarks"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_contracts_on_company_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
    t.index ["created_by_id"], name: "index_departments_on_created_by_id"
  end

  create_table "device_session_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "ip_address"
    t.text "os"
    t.string "device_name"
    t.string "device_id", null: false
    t.bigint "user_id", null: false
    t.string "action"
    t.datetime "at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_device_session_records_on_user_id"
  end

  create_table "employee_action_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "action_by_id"
    t.bigint "employee_id"
    t.string "action_type"
    t.datetime "action_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["action_by_id"], name: "index_employee_action_histories_on_action_by_id"
    t.index ["employee_id"], name: "index_employee_action_histories_on_employee_id"
  end

  create_table "employee_allowances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", null: false
    t.index ["employee_id"], name: "index_employee_allowances_on_employee_id"
  end

  create_table "employee_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.bigint "employee_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "schedule_id"
    t.index ["employee_id"], name: "index_employee_schedules_on_employee_id"
    t.index ["schedule_id"], name: "index_employee_schedules_on_schedule_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "employee_id", null: false
    t.string "status", default: "A"
    t.integer "biometric_no"
    t.string "first_name", null: false
    t.string "middle_name", default: ""
    t.string "last_name", null: false
    t.string "suffix", default: ""
    t.bigint "position_id", null: false
    t.bigint "department_id"
    t.bigint "assigned_area_id"
    t.bigint "job_classification_id"
    t.bigint "salary_mode_id", null: false
    t.datetime "date_hired", precision: nil, null: false
    t.boolean "allow_ers_attendance", default: false
    t.datetime "date_regularized", precision: nil
    t.datetime "date_resigned", precision: nil
    t.bigint "employment_status_id", null: false
    t.string "sex", null: false
    t.datetime "birthdate", precision: nil, null: false
    t.string "work_sched_type", null: false
    t.string "work_sched_start"
    t.string "work_sched_end"
    t.json "work_sched_days"
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
    t.decimal "compensation", precision: 8, scale: 2, null: false
    t.string "emergency_contact_person", default: ""
    t.string "emergency_contact_number", default: ""
    t.text "remarks"
    t.text "others"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "leave_credit", precision: 8, scale: 2, default: "10.0", null: false
    t.bigint "company_account_id"
    t.string "emergency_contact_relationship", default: ""
    t.string "profile"
    t.string "password_digest"
    t.index ["assigned_area_id"], name: "index_employees_on_assigned_area_id"
    t.index ["company_account_id"], name: "index_employees_on_company_account_id"
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

  create_table "employment_statuses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "status", default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "failed_time_keepings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "details"
    t.integer "emp_bio_no"
    t.bigint "company_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_failed_time_keepings_on_company_id"
  end

  create_table "holidays", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type_of_holiday", null: false
    t.date "date", null: false
    t.bigint "company_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title", null: false
    t.index ["company_id"], name: "index_holidays_on_company_id"
  end

  create_table "job_classifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_job_classifications_on_company_id"
    t.index ["created_by_id"], name: "index_job_classifications_on_created_by_id"
  end

  create_table "leaves", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "leave_type"
    t.text "reason"
    t.string "status", limit: 1, default: "P"
    t.bigint "actioned_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "half_day", default: false
    t.bigint "employee_id"
    t.bigint "company_id"
    t.integer "origin", limit: 1, default: 0
    t.index ["actioned_by_id"], name: "index_leaves_on_actioned_by_id"
    t.index ["company_id"], name: "index_leaves_on_company_id"
    t.index ["employee_id"], name: "index_leaves_on_employee_id"
  end

  create_table "official_businesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "client"
    t.text "reason"
    t.string "status", limit: 1, default: "P"
    t.bigint "actioned_by_id"
    t.integer "origin", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "company_id"
    t.bigint "employee_id"
    t.index ["actioned_by_id"], name: "index_official_businesses_on_actioned_by_id"
    t.index ["company_id"], name: "index_official_businesses_on_company_id"
    t.index ["employee_id"], name: "index_official_businesses_on_employee_id"
  end

  create_table "offset_overtimes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "overtime_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "offset_id"
    t.index ["offset_id"], name: "index_offset_overtimes_on_offset_id"
    t.index ["overtime_id"], name: "index_offset_overtimes_on_overtime_id"
  end

  create_table "offsets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "employee_id"
    t.date "offset_date"
    t.integer "origin", default: 0
    t.text "reason"
    t.bigint "actioned_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "P"
    t.index ["actioned_by_id"], name: "index_offsets_on_actioned_by_id"
    t.index ["company_id"], name: "index_offsets_on_company_id"
    t.index ["employee_id"], name: "index_offsets_on_employee_id"
  end

  create_table "on_payroll_adjustments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "payroll_id", null: false
    t.bigint "employee_id", null: false
    t.string "description", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "adjustment_type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_on_payroll_adjustments_on_employee_id"
    t.index ["payroll_id"], name: "index_on_payroll_adjustments_on_payroll_id"
  end

  create_table "on_payroll_allowances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.text "name", null: false
    t.bigint "payroll_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_on_payroll_allowances_on_employee_id"
    t.index ["payroll_id"], name: "index_on_payroll_allowances_on_payroll_id"
  end

  create_table "on_payroll_compensations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.decimal "compensation", precision: 8, scale: 2
    t.bigint "payroll_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "company_account_id"
    t.bigint "position_id"
    t.bigint "department_id"
    t.bigint "salary_mode_id"
    t.string "work_sched_type"
    t.index ["company_account_id"], name: "index_on_payroll_compensations_on_company_account_id"
    t.index ["department_id"], name: "index_on_payroll_compensations_on_department_id"
    t.index ["employee_id"], name: "index_on_payroll_compensations_on_employee_id"
    t.index ["payroll_id"], name: "index_on_payroll_compensations_on_payroll_id"
    t.index ["position_id"], name: "index_on_payroll_compensations_on_position_id"
    t.index ["salary_mode_id"], name: "index_on_payroll_compensations_on_salary_mode_id"
  end

  create_table "overtimes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "company_id"
    t.integer "origin", default: 0
    t.text "output"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.bigint "actioned_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "P"
    t.boolean "billable", default: true
    t.bigint "offset_id"
    t.index ["actioned_by_id"], name: "index_overtimes_on_actioned_by_id"
    t.index ["company_id"], name: "index_overtimes_on_company_id"
    t.index ["employee_id"], name: "index_overtimes_on_employee_id"
    t.index ["offset_id"], name: "index_overtimes_on_offset_id"
  end

  create_table "page_accesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "page", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position", null: false
    t.index ["access_code"], name: "index_page_accesses_on_access_code"
  end

  create_table "page_action_accesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "action", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["access_code"], name: "index_page_action_accesses_on_access_code"
  end

  create_table "pagibigs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "title", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "I"
  end

  create_table "payroll_accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "payroll_id"
    t.bigint "company_account_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "approved", default: false
    t.bigint "approved_by_id"
    t.index ["approved_by_id"], name: "index_payroll_accounts_on_approved_by_id"
    t.index ["company_account_id"], name: "index_payroll_accounts_on_company_account_id"
    t.index ["payroll_id"], name: "index_payroll_accounts_on_payroll_id"
  end

  create_table "payroll_comments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "payroll_id", null: false
    t.string "comment_type", default: "text"
    t.text "comment"
    t.bigint "user_id", null: false
    t.datetime "time_sent", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["payroll_id"], name: "index_payroll_comments_on_payroll_id"
    t.index ["user_id"], name: "index_payroll_comments_on_user_id"
  end

  create_table "payrolls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "from", null: false
    t.date "to", null: false
    t.bigint "company_id", null: false
    t.string "status", limit: 1, default: "P"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "remarks"
    t.date "pay_date"
    t.bigint "pagibig_id"
    t.bigint "philhealth_id"
    t.bigint "sss_contribution_id"
    t.index ["company_id"], name: "index_payrolls_on_company_id"
    t.index ["from"], name: "index_payrolls_on_from"
    t.index ["pagibig_id"], name: "index_payrolls_on_pagibig_id"
    t.index ["philhealth_id"], name: "index_payrolls_on_philhealth_id"
    t.index ["sss_contribution_id"], name: "index_payrolls_on_sss_contribution_id"
    t.index ["to"], name: "index_payrolls_on_to"
  end

  create_table "philhealths", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "percentage_deduction", precision: 8, scale: 2, null: false
    t.string "title", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "I"
  end

  create_table "pms_devices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "device_id", null: false
    t.string "device_name", null: false
    t.boolean "allowed", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_pms_devices_on_company_id"
  end

  create_table "positions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "code", null: false
    t.bigint "created_by_id"
    t.string "status", default: "A"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["company_id"], name: "index_positions_on_company_id"
    t.index ["created_by_id"], name: "index_positions_on_created_by_id"
  end

  create_table "salary_modes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_salary_modes_on_code"
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "remarks"
    t.bigint "company_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "department_id"
    t.index ["company_id"], name: "index_schedules_on_company_id"
    t.index ["department_id"], name: "index_schedules_on_department_id"
  end

  create_table "session_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "first_logged_in", precision: nil
    t.datetime "previous_logged_in", precision: nil
    t.datetime "recent_logged_in", precision: nil
    t.string "status", default: "I"
    t.integer "sign_in_count", default: 0
    t.string "current_device", default: ""
    t.string "current_device_id", null: false
    t.string "current_os", default: ""
    t.string "current_ip_address", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_session_records_on_user_id"
  end

  create_table "social_security_systems", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "com_from", precision: 8, scale: 2, null: false
    t.decimal "com_to", precision: 8, scale: 2, null: false
    t.decimal "employe_compensation", precision: 8, scale: 2, null: false
    t.decimal "mandatory_fund", precision: 8, scale: 2, null: false
    t.decimal "salary_credit_total", precision: 8, scale: 2, null: false
    t.decimal "rss_er", precision: 8, scale: 2, null: false
    t.decimal "rss_ee", precision: 8, scale: 2, null: false
    t.decimal "rss_total", precision: 8, scale: 2, null: false
    t.decimal "ec_er", precision: 8, scale: 2, null: false
    t.decimal "ec_ee", precision: 8, scale: 2, null: false
    t.decimal "ec_total", precision: 8, scale: 2, null: false
    t.decimal "mpf_er", precision: 8, scale: 2, null: false
    t.decimal "mpf_ee", precision: 8, scale: 2, null: false
    t.decimal "mpf_total", precision: 8, scale: 2, null: false
    t.decimal "total_er", precision: 8, scale: 2, null: false
    t.decimal "total_ee", precision: 8, scale: 2, null: false
    t.decimal "final_total", precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "sss_contribution_id"
    t.index ["sss_contribution_id"], name: "index_social_security_systems_on_sss_contribution_id"
  end

  create_table "sss_contributions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "status", default: "I", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "support_chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "encrypted_message"
    t.text "encrypted_message_iv"
    t.text "encrypted_message_salt"
    t.bigint "user_id_id"
    t.bigint "admin_id_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["admin_id_id"], name: "index_support_chats_on_admin_id_id"
    t.index ["user_id_id"], name: "index_support_chats_on_user_id_id"
  end

  create_table "time_keepings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "biometric_no", null: false
    t.datetime "date", precision: nil, null: false
    t.integer "status", null: false
    t.integer "verified", default: 1, null: false
    t.integer "work_code", default: 0, null: false
    t.integer "record_type", default: 1, null: false
    t.integer "device_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "file_uid", default: ""
    t.string "from_file", default: ""
    t.index ["company_id"], name: "index_time_keepings_on_company_id"
  end

  create_table "type_of_leaves", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "status", default: "A"
    t.boolean "with_pay", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "code", null: false
  end

  create_table "undertimes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.string "status", default: "P"
    t.bigint "company_id"
    t.bigint "employee_id"
    t.integer "origin", default: 0
    t.text "reason"
    t.bigint "actioned_by_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["actioned_by_id"], name: "index_undertimes_on_actioned_by_id"
    t.index ["company_id"], name: "index_undertimes_on_company_id"
    t.index ["employee_id"], name: "index_undertimes_on_employee_id"
  end

  create_table "user_page_action_accesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "page_access_id", null: false
    t.bigint "page_action_access_id", null: false
    t.string "status", default: "I", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["page_access_id"], name: "index_user_page_action_accesses_on_page_access_id"
    t.index ["page_action_access_id"], name: "index_user_page_action_accesses_on_page_action_access_id"
    t.index ["user_id"], name: "index_user_page_action_accesses_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: ""
    t.string "password_digest"
    t.string "position", default: "HR-staff"
    t.string "name", default: ""
    t.boolean "admin", default: false
    t.string "username", null: false
    t.string "status", default: "A"
    t.boolean "system_default", default: false
    t.boolean "disabled", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at", precision: nil
    t.bigint "company_id", null: false
    t.boolean "online", default: false
    t.text "page_accesses"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "assigned_areas", "companies"
  add_foreign_key "assigned_areas", "users", column: "created_by_id"
  add_foreign_key "company_accounts", "companies"
  add_foreign_key "company_accounts", "users", column: "created_by_id"
  add_foreign_key "contracts", "companies"
  add_foreign_key "departments", "users", column: "created_by_id"
  add_foreign_key "employee_action_histories", "users", column: "action_by_id"
  add_foreign_key "employee_allowances", "employees"
  add_foreign_key "employee_schedules", "employees"
  add_foreign_key "employee_schedules", "schedules"
  add_foreign_key "employees", "company_accounts"
  add_foreign_key "employees", "users", column: "created_by_id"
  add_foreign_key "holidays", "companies"
  add_foreign_key "job_classifications", "companies"
  add_foreign_key "job_classifications", "users", column: "created_by_id"
  add_foreign_key "leaves", "companies"
  add_foreign_key "leaves", "employees"
  add_foreign_key "leaves", "users", column: "actioned_by_id"
  add_foreign_key "official_businesses", "companies"
  add_foreign_key "official_businesses", "employees"
  add_foreign_key "official_businesses", "users", column: "actioned_by_id"
  add_foreign_key "offset_overtimes", "offsets"
  add_foreign_key "offset_overtimes", "overtimes"
  add_foreign_key "offsets", "companies"
  add_foreign_key "offsets", "employees"
  add_foreign_key "offsets", "users", column: "actioned_by_id"
  add_foreign_key "on_payroll_adjustments", "employees"
  add_foreign_key "on_payroll_adjustments", "payrolls"
  add_foreign_key "on_payroll_allowances", "employees"
  add_foreign_key "on_payroll_allowances", "payrolls"
  add_foreign_key "on_payroll_compensations", "company_accounts"
  add_foreign_key "on_payroll_compensations", "departments"
  add_foreign_key "on_payroll_compensations", "employees"
  add_foreign_key "on_payroll_compensations", "payrolls"
  add_foreign_key "on_payroll_compensations", "positions"
  add_foreign_key "on_payroll_compensations", "salary_modes"
  add_foreign_key "overtimes", "companies"
  add_foreign_key "overtimes", "employees"
  add_foreign_key "overtimes", "offsets"
  add_foreign_key "overtimes", "users", column: "actioned_by_id"
  add_foreign_key "payroll_accounts", "company_accounts"
  add_foreign_key "payroll_accounts", "payrolls"
  add_foreign_key "payroll_accounts", "users", column: "approved_by_id"
  add_foreign_key "payroll_comments", "payrolls"
  add_foreign_key "payroll_comments", "users"
  add_foreign_key "payrolls", "companies"
  add_foreign_key "payrolls", "pagibigs"
  add_foreign_key "payrolls", "philhealths"
  add_foreign_key "payrolls", "sss_contributions"
  add_foreign_key "pms_devices", "companies"
  add_foreign_key "positions", "companies"
  add_foreign_key "positions", "users", column: "created_by_id"
  add_foreign_key "schedules", "companies"
  add_foreign_key "schedules", "departments"
  add_foreign_key "social_security_systems", "sss_contributions"
  add_foreign_key "undertimes", "companies"
  add_foreign_key "undertimes", "employees"
  add_foreign_key "undertimes", "users", column: "actioned_by_id"
  add_foreign_key "users", "companies"
end
