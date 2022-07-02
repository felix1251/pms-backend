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

ActiveRecord::Schema.define(version: 2022_07_01_134643) do

  create_table "companies", force: :cascade do |t|
    t.string "code", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_accesses", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "page", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_action_accesses", force: :cascade do |t|
    t.string "access_code", null: false
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_page_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "page_access_id", null: false
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_access_id"], name: "index_user_page_accesses_on_page_access_id"
    t.index ["user_id"], name: "index_user_page_accesses_on_user_id"
  end

  create_table "user_page_action_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "page_access_id", null: false
    t.integer "page_action_access_id", null: false
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_access_id"], name: "index_user_page_action_accesses_on_page_access_id"
    t.index ["page_action_access_id"], name: "index_user_page_action_accesses_on_page_action_access_id"
    t.index ["user_id"], name: "index_user_page_action_accesses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest"
    t.string "position", default: "HR-staff"
    t.string "name", default: ""
    t.boolean "hr_head", default: false
    t.string "username", null: false
    t.string "status", default: "A"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

end
