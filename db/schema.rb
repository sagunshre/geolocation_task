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

ActiveRecord::Schema[7.0].define(version: 2023_11_23_142303) do
  create_table "devices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geolocations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "continent"
    t.string "country", null: false
    t.string "region"
    t.string "city", null: false
    t.decimal "latitude", precision: 17, scale: 14, null: false
    t.decimal "longitude", precision: 17, scale: 14, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "device_id"
    t.string "zip"
    t.string "ip"
    t.string "hostname"
    t.index ["device_id"], name: "index_geolocations_on_device_id"
  end

  add_foreign_key "geolocations", "devices"
end
