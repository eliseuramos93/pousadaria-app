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

ActiveRecord::Schema[7.1].define(version: 2023_11_03_144656) do
  create_table "addresses", force: :cascade do |t|
    t.integer "inn_id", null: false
    t.string "street_name"
    t.string "number"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_addresses_on_inn_id"
  end

  create_table "inns", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "brand_name"
    t.string "registration_number"
    t.string "phone_number"
    t.string "description"
    t.boolean "pet_friendly"
    t.string "policy"
    t.time "checkin_time"
    t.time "checkout_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_inns_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "inn_id", null: false
    t.boolean "bank_transfer"
    t.boolean "credit_card"
    t.boolean "debit_card"
    t.boolean "cash"
    t.boolean "deposit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_payment_methods_on_inn_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "area"
    t.integer "max_capacity"
    t.float "rent_price"
    t.integer "status", default: 0
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_bathroom", default: false
    t.boolean "has_balcony", default: false
    t.boolean "has_air_conditioner", default: false
    t.boolean "has_tv", default: false
    t.boolean "has_wardrobe", default: false
    t.boolean "has_vault", default: false
    t.boolean "is_accessible", default: false
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "seasonal_rates", force: :cascade do |t|
    t.integer "room_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seasonal_rates_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "inns"
  add_foreign_key "inns", "users"
  add_foreign_key "payment_methods", "inns"
  add_foreign_key "rooms", "inns"
  add_foreign_key "seasonal_rates", "rooms"
end
