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

ActiveRecord::Schema[8.0].define(version: 2025_07_03_195315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "delivery_method", ["self_pickup", "delivery"]
  create_enum "order_status", ["pending", "confirmed", "in_progress", "out_for_delivery", "delivered", "cancelled"]

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "sandwich_id", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "charged_price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["sandwich_id"], name: "index_cart_items_on_sandwich_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "sandwich_id", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "charged_price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["sandwich_id"], name: "index_order_items_on_sandwich_id"
  end

  create_table "orders", force: :cascade do |t|
    t.enum "delivery_method", default: "self_pickup", null: false, enum_type: "delivery_method"
    t.datetime "delivery_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "order_status", default: "pending", null: false, enum_type: "order_status"
    t.bigint "shop_id", null: false
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "sandwiches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sandwiches_on_name"
  end

  create_table "shop_sandwiches", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "sandwich_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sandwich_id"], name: "index_shop_sandwiches_on_sandwich_id"
    t.index ["shop_id", "sandwich_id"], name: "index_shop_sandwiches_on_shop_id_and_sandwich_id", unique: true
    t.index ["shop_id"], name: "index_shop_sandwiches_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.jsonb "address", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_shops_on_address", using: :gin
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "sandwiches"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "sandwiches"
  add_foreign_key "orders", "shops"
  add_foreign_key "shop_sandwiches", "sandwiches"
  add_foreign_key "shop_sandwiches", "shops"
end
