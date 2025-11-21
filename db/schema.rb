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

ActiveRecord::Schema[8.1].define(version: 2025_11_22_174043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "application_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "field_type", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["key"], name: "index_application_settings_on_key", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "facebook_url"
    t.string "first_name", null: false
    t.string "instagram_profile_url"
    t.string "last_name", null: false
    t.text "notes"
    t.string "phone"
    t.string "tiktok_profile_url"
    t.datetime "updated_at", null: false
    t.string "whatsapp_number"
  end

  create_table "delivery_partners", force: :cascade do |t|
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.decimal "default_cost", precision: 10, scale: 2
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.bigint "original_sale_id", null: false
    t.decimal "price_difference"
    t.bigint "replacement_product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["original_sale_id"], name: "index_exchanges_on_original_sale_id"
    t.index ["replacement_product_id"], name: "index_exchanges_on_replacement_product_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.decimal "auto_suggested_selling_price", precision: 10, scale: 2
    t.string "category"
    t.datetime "created_at", null: false
    t.decimal "current_cost_price", precision: 10, scale: 2, null: false
    t.bigint "current_vendor_id"
    t.text "description"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["current_vendor_id"], name: "index_products_on_current_vendor_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.decimal "delivery_cost", precision: 10, scale: 2, default: "0.0"
    t.bigint "delivery_partner_id"
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.text "notes"
    t.string "payment_method", null: false
    t.bigint "product_id", null: false
    t.decimal "profit", precision: 10, scale: 2
    t.integer "quantity", default: 1, null: false
    t.decimal "selling_price", precision: 10, scale: 2, null: false
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["delivery_partner_id"], name: "index_sales_on_delivery_partner_id"
    t.index ["product_id"], name: "index_sales_on_product_id"
  end

  create_table "sales_returns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "reason"
    t.decimal "refund_amount", precision: 10, scale: 2
    t.integer "return_quantity", null: false
    t.bigint "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_sales_returns_on_sale_id"
  end

  create_table "social_media_posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "hashtags", default: [], array: true
    t.jsonb "metadata", default: {}
    t.integer "platforms_posted", default: [], array: true
    t.jsonb "post_url_per_platform", default: {}
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "address"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendor_price_histories", force: :cascade do |t|
    t.decimal "cost_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "vendor_id", null: false
    t.index ["product_id"], name: "index_vendor_price_histories_on_product_id"
    t.index ["vendor_id"], name: "index_vendor_price_histories_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "exchanges", "products", column: "replacement_product_id"
  add_foreign_key "exchanges", "sales", column: "original_sale_id"
  add_foreign_key "products", "vendors", column: "current_vendor_id"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "delivery_partners"
  add_foreign_key "sales", "products"
  add_foreign_key "sales_returns", "sales"
  add_foreign_key "vendor_price_histories", "products"
  add_foreign_key "vendor_price_histories", "vendors"
end
