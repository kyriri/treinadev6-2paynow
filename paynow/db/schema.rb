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

ActiveRecord::Schema.define(version: 2021_06_11_133648) do

  create_table "buyers", force: :cascade do |t|
    t.string "token"
    t.string "cpf"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_buyers_on_token", unique: true
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

  add_foreign_key "products", "seller_companies"
end
