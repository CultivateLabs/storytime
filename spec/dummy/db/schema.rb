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

ActiveRecord::Schema[8.1].define(version: 2026_04_08_001637) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "storytime_actions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "guid"
    t.string "name"
    t.datetime "updated_at", precision: nil
    t.index ["guid"], name: "index_storytime_actions_on_guid"
  end

  create_table "storytime_autosaves", id: :serial, force: :cascade do |t|
    t.integer "autosavable_id"
    t.string "autosavable_type"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.index ["autosavable_type", "autosavable_id"], name: "autosavable_index"
    t.index ["site_id"], name: "index_storytime_autosaves_on_site_id"
  end

  create_table "storytime_comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: nil
    t.integer "post_id"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["post_id"], name: "index_storytime_comments_on_post_id"
    t.index ["site_id"], name: "index_storytime_comments_on_site_id"
    t.index ["user_id"], name: "index_storytime_comments_on_user_id"
  end

  create_table "storytime_links", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "linkable_id"
    t.string "linkable_type"
    t.integer "position"
    t.integer "storytime_navigation_id"
    t.string "text"
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
    t.index ["linkable_type", "linkable_id"], name: "index_storytime_links_on_linkable_type_and_linkable_id"
    t.index ["position"], name: "index_storytime_links_on_position"
    t.index ["storytime_navigation_id"], name: "index_storytime_links_on_storytime_navigation_id"
  end

  create_table "storytime_media", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "file"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["site_id"], name: "index_storytime_media_on_site_id"
    t.index ["user_id"], name: "index_storytime_media_on_user_id"
  end

  create_table "storytime_memberships", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "site_id"
    t.integer "storytime_role_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["site_id"], name: "index_storytime_memberships_on_site_id"
    t.index ["storytime_role_id"], name: "index_storytime_memberships_on_storytime_role_id"
    t.index ["user_id"], name: "index_storytime_memberships_on_user_id"
  end

  create_table "storytime_navigations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "handle"
    t.string "name"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["site_id"], name: "index_storytime_navigations_on_site_id"
  end

  create_table "storytime_permissions", id: :serial, force: :cascade do |t|
    t.integer "action_id"
    t.datetime "created_at", precision: nil
    t.integer "role_id"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.index ["action_id"], name: "index_storytime_permissions_on_action_id"
    t.index ["role_id"], name: "index_storytime_permissions_on_role_id"
    t.index ["site_id"], name: "index_storytime_permissions_on_site_id"
  end

  create_table "storytime_posts", id: :serial, force: :cascade do |t|
    t.integer "blog_id"
    t.string "canonical_url"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.text "excerpt"
    t.boolean "featured", default: false
    t.integer "featured_media_id"
    t.boolean "notifications_enabled", default: false
    t.datetime "notifications_sent_at", precision: nil
    t.datetime "published_at", precision: nil
    t.integer "secondary_media_id"
    t.integer "site_id"
    t.string "slug"
    t.string "title"
    t.string "type"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.string "video_url"
    t.index ["blog_id"], name: "index_storytime_posts_on_blog_id"
    t.index ["slug"], name: "index_storytime_posts_on_slug"
    t.index ["user_id"], name: "index_storytime_posts_on_user_id"
  end

  create_table "storytime_roles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_storytime_roles_on_name"
  end

  create_table "storytime_sites", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "custom_domain"
    t.string "discourse_name"
    t.string "disqus_forum_shortname"
    t.string "ga_tracking_id"
    t.string "layout"
    t.integer "post_slug_style", default: 0
    t.integer "root_post_id"
    t.string "subscription_email_from"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["root_post_id"], name: "index_storytime_sites_on_root_post_id"
    t.index ["user_id"], name: "index_storytime_sites_on_user_id"
  end

  create_table "storytime_snippets", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: nil
    t.string "name"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_storytime_snippets_on_name"
  end

  create_table "storytime_subscriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "email"
    t.integer "site_id"
    t.boolean "subscribed", default: true
    t.string "token"
    t.datetime "updated_at", precision: nil
    t.index ["token"], name: "index_storytime_subscriptions_on_token"
  end

  create_table "storytime_taggings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "post_id"
    t.integer "site_id"
    t.integer "tag_id"
    t.datetime "updated_at", precision: nil
    t.index ["post_id"], name: "index_storytime_taggings_on_post_id"
    t.index ["site_id"], name: "index_storytime_taggings_on_site_id"
    t.index ["tag_id"], name: "index_storytime_taggings_on_tag_id"
  end

  create_table "storytime_tags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "storytime_versions", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: nil
    t.integer "site_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.integer "versionable_id"
    t.string "versionable_type"
    t.index ["site_id"], name: "index_storytime_versions_on_site_id"
    t.index ["user_id"], name: "index_storytime_versions_on_user_id"
    t.index ["versionable_type", "versionable_id"], name: "versionable_index"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "storytime_name"
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "widgets", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  add_foreign_key "storytime_links", "storytime_navigations"
end
