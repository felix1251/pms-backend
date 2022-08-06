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

ActiveRecord::Schema.define(version: 2022_07_07_054501) do

  create_table "companies", force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_companies_on_code"
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
