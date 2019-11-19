# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_19_045347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "missions", force: :cascade do |t|
    t.string "name", limit: 48, null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "deadline"
    t.integer "work_state", default: 0
    t.integer "priority", default: 0
    t.bigint "user_id"
    t.index ["deadline"], name: "index_missions_on_deadline"
    t.index ["name"], name: "index_missions_on_name"
    t.index ["priority"], name: "index_missions_on_priority"
    t.index ["user_id"], name: "index_missions_on_user_id"
    t.index ["work_state"], name: "index_missions_on_work_state"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.integer "missions_count", default: 0
    t.boolean "admin", default: false
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
