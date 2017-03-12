# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170312122454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "link"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.string   "word"
    t.integer  "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "page_id"
    t.string   "context"
    t.index ["page_id"], name: "index_results_on_page_id", using: :btree
    t.index ["search_id"], name: "index_results_on_search_id", using: :btree
  end

  create_table "searches", force: :cascade do |t|
    t.string   "query"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "status"
    t.string   "country_code"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_searches_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "sign_in_count",      default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
  end

  create_table "words", force: :cascade do |t|
    t.string   "phrase"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_words_on_category_id", using: :btree
  end

  add_foreign_key "results", "pages"
  add_foreign_key "searches", "users"
  add_foreign_key "words", "categories"
end
