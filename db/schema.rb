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

ActiveRecord::Schema[7.0].define(version: 2023_07_13_160743) do
  create_table "api_keys", force: :cascade do |t|
    t.string "bearer_type"
    t.integer "bearer_id"
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bearer_type", "bearer_id"], name: "index_api_keys_on_bearer"
    t.index ["token"], name: "index_api_keys_on_token", unique: true
  end

  create_table "one_time_passwords", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "otp_secret", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["otp_secret"], name: "index_one_time_passwords_on_otp_secret", unique: true
    t.index ["user_id"], name: "index_one_time_passwords_on_user_id"
  end

  create_table "user_config", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "otp_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_config_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
