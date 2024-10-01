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

ActiveRecord::Schema[7.2].define(version: 2024_09_25_104519) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "buyers", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_buyers_on_user_id"
  end

  create_table "ebook_tags", force: :cascade do |t|
    t.integer "ebook_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_ebook_tags_on_ebook_id"
    t.index ["tag_id"], name: "index_ebook_tags_on_tag_id"
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
    t.string "genre"
    t.integer "user_id"
    t.index ["user_id"], name: "index_ebooks_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "purchased_at"
    t.decimal "price", precision: 5, scale: 2
    t.integer "buyer_id", null: false
    t.integer "seller_id", null: false
    t.integer "ebook_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["ebook_id"], name: "index_purchases_on_ebook_id"
    t.index ["seller_id"], name: "index_purchases_on_seller_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sellers_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.datetime "password_expires_at"
    t.boolean "active", default: true
    t.datetime "inactivated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buyers", "users"
  add_foreign_key "ebook_tags", "ebooks"
  add_foreign_key "ebook_tags", "tags"
  add_foreign_key "ebooks", "users"
  add_foreign_key "purchases", "buyers"
  add_foreign_key "purchases", "ebooks"
  add_foreign_key "purchases", "sellers"
  add_foreign_key "sellers", "users"
end
