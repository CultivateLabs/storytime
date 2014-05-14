# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140513162745) do

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "storytime_media", force: true do |t|
    t.string   "file"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_media", ["user_id"], name: "index_storytime_media_on_user_id"

  create_table "storytime_pages", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_pages", ["user_id"], name: "index_storytime_pages_on_user_id"

  create_table "storytime_posts", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.text     "excerpt"
    t.boolean  "published"
    t.string   "post_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_posts", ["user_id"], name: "index_storytime_posts_on_user_id"

  create_table "storytime_sites", force: true do |t|
    t.string   "title"
    t.integer  "post_slug_style",       default: 0
    t.string   "ga_tracking_id"
    t.integer  "root_page_content",     default: 0
    t.text     "header"
    t.text     "footer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "selected_root_page_id"
  end

  add_index "storytime_sites", ["selected_root_page_id"], name: "index_storytime_sites_on_selected_root_page_id"

  create_table "storytime_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storytime_users", ["email"], name: "index_storytime_users_on_email", unique: true
  add_index "storytime_users", ["reset_password_token"], name: "index_storytime_users_on_reset_password_token", unique: true

end
