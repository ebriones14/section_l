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

ActiveRecord::Schema[8.1].define(version: 2026_10_07_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "city_gem_neighbourhoods", force: :cascade do |t|
    t.bigint "city_gem_id", null: false
    t.bigint "neighbourhood_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_gem_id", "neighbourhood_id"], name: "idx_on_city_gem_id_neighbourhood_id_c0b3755852", unique: true
    t.index ["city_gem_id"], name: "index_city_gem_neighbourhoods_on_city_gem_id"
    t.index ["neighbourhood_id"], name: "index_city_gem_neighbourhoods_on_neighbourhood_id"
  end

  create_table "city_gems", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.string "short", null: false
    t.text "long", null: false
    t.string "maps", null: false
    t.string "image_url"
    t.string "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "neighbourhoods", force: :cascade do |t|
    t.string "name", null: false
    t.string "hashtag"
    t.text "hashtag_description"
    t.text "description"
    t.string "city", null: false
    t.string "map_pin"
    t.string "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city", "name"], name: "index_neighbourhoods_on_city_and_name", unique: true
  end

  create_table "properties", force: :cascade do |t|
    t.string "name", null: false
    t.string "city", null: false
    t.string "slug", null: false
    t.text "description", null: false
    t.string "hero_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address", null: false
    t.index ["slug"], name: "index_properties_on_slug", unique: true
  end

  create_table "property_neighbourhoods", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "neighbourhood_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neighbourhood_id"], name: "index_property_neighbourhoods_on_neighbourhood_id"
    t.index ["property_id", "neighbourhood_id"], name: "idx_on_property_id_neighbourhood_id_4d2c9f3800", unique: true
    t.index ["property_id"], name: "index_property_neighbourhoods_on_property_id"
  end

  add_foreign_key "city_gem_neighbourhoods", "city_gems"
  add_foreign_key "city_gem_neighbourhoods", "neighbourhoods"
  add_foreign_key "property_neighbourhoods", "neighbourhoods"
  add_foreign_key "property_neighbourhoods", "properties"
end
