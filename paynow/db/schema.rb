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

ActiveRecord::Schema.define(version: 2021_06_28_061824) do

  create_table "buyers", force: :cascade do |t|
    t.string "token"
    t.string "cpf"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_buyers_on_token", unique: true
  end

  create_table "buyers_seller_companies", id: false, force: :cascade do |t|
    t.integer "buyer_id", null: false
    t.integer "seller_company_id", null: false
    t.index ["buyer_id"], name: "index_buyers_seller_companies_on_buyer_id"
    t.index ["seller_company_id"], name: "index_buyers_seller_companies_on_seller_company_id"
  end

  create_table "charge_orders", force: :cascade do |t|
    t.string "token", null: false
    t.decimal "value_before_discount", null: false
    t.decimal "value_after_discount"
    t.date "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seller_company_id"
    t.integer "buyer_id"
    t.integer "product_id"
    t.string "buyer_email"
    t.integer "payment_route_id"
    t.index ["buyer_id"], name: "index_charge_orders_on_buyer_id"
    t.index ["payment_route_id"], name: "index_charge_orders_on_payment_route_id"
    t.index ["product_id"], name: "index_charge_orders_on_product_id"
    t.index ["seller_company_id"], name: "index_charge_orders_on_seller_company_id"
    t.index ["token"], name: "index_charge_orders_on_token", unique: true
  end

  create_table "payment_method_options", force: :cascade do |t|
    t.integer "category", null: false
    t.string "provider", null: false
    t.integer "status", default: 0, null: false
    t.decimal "fee_as_percentage", null: false
    t.decimal "max_fee_in_brl", precision: 7, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_routes", force: :cascade do |t|
    t.integer "seller_company_id"
    t.integer "payment_method_option_id"
    t.string "token", null: false
    t.integer "bank_code"
    t.string "bank_branch"
    t.string "bank_account"
    t.string "pix_key"
    t.string "token_before_card_operator"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_method_option_id"], name: "index_payment_routes_on_payment_method_option_id"
    t.index ["seller_company_id"], name: "index_payment_routes_on_seller_company_id"
    t.index ["token"], name: "index_payment_routes_on_token", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "token", null: false
    t.string "name"
    t.decimal "price", precision: 7, scale: 2
    t.integer "seller_company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seller_company_id"], name: "index_products_on_seller_company_id"
    t.index ["token"], name: "index_products_on_token", unique: true
  end

  create_table "seller_companies", force: :cascade do |t|
    t.string "name"
    t.string "formal_name"
    t.string "cnpj"
    t.string "billing_email"
    t.integer "access_status", default: 5, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token", null: false
    t.index ["token"], name: "index_seller_companies_on_token", unique: true
  end

  add_foreign_key "charge_orders", "buyers"
  add_foreign_key "charge_orders", "payment_routes"
  add_foreign_key "charge_orders", "products"
  add_foreign_key "charge_orders", "seller_companies"
  add_foreign_key "products", "seller_companies"
end
