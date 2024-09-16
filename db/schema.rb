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

ActiveRecord::Schema[7.2].define(version: 2024_09_16_095142) do
  create_table "buyers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_buyers_on_user_id"
  end

  create_table "ebook_buyers", force: :cascade do |t|
    t.integer "buyer_id", null: false
    t.integer "ebook_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_ebook_buyers_on_buyer_id"
    t.index ["ebook_id"], name: "index_ebook_buyers_on_ebook_id"
  end

  create_table "ebook_sellers", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.integer "ebook_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_ebook_sellers_on_ebook_id"
    t.index ["seller_id"], name: "index_ebook_sellers_on_seller_id"
  end

  create_table "ebooks", force: :cascade do |t|
    t.string "title"
    t.integer "status"
    t.decimal "price", precision: 5, scale: 2
    t.string "authors"
    t.string "publisher"
    t.datetime "publication_date"
    t.integer "pages"
    t.string "isbn"
    t.integer "sales", default: 0
    t.integer "views", default: 0
    t.integer "preview_downloads", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sellers_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "buyers", "users"
  add_foreign_key "ebook_buyers", "buyers"
  add_foreign_key "ebook_buyers", "ebooks"
  add_foreign_key "ebook_sellers", "ebooks"
  add_foreign_key "ebook_sellers", "sellers"
  add_foreign_key "sellers", "users"
  add_foreign_key "user_profiles", "users"
end
