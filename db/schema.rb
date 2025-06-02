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

ActiveRecord::Schema[8.0].define(version: 2025_05_31_203858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "matters", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "state", default: "new", null: false
    t.datetime "due_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["due_date"], name: "index_matters_on_due_date"
    t.index ["state"], name: "index_matters_on_state"
    t.index ["user_id"], name: "index_matters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firm_name"
    t.integer "role", default: 0, null: false
    t.string "phone", null: false
    t.index ["firm_name"], name: "index_users_on_firm_name"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "matters", "users"
end
