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

ActiveRecord::Schema[7.2].define(version: 2015_05_29_192058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "storytime_actions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "guid"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["guid"], name: "index_storytime_actions_on_guid"
  end

  create_table "storytime_autosaves", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "autosavable_type"
    t.integer "autosavable_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["autosavable_type", "autosavable_id"], name: "autosavable_index"
    t.index ["site_id"], name: "index_storytime_autosaves_on_site_id"
  end

  create_table "storytime_comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["post_id"], name: "index_storytime_comments_on_post_id"
    t.index ["site_id"], name: "index_storytime_comments_on_site_id"
    t.index ["user_id"], name: "index_storytime_comments_on_user_id"
  end

  create_table "storytime_links", id: :serial, force: :cascade do |t|
    t.string "text"
    t.integer "storytime_navigation_id"
    t.string "linkable_type"
    t.integer "linkable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.string "url"
    t.index ["linkable_type", "linkable_id"], name: "index_storytime_links_on_linkable_type_and_linkable_id"
    t.index ["position"], name: "index_storytime_links_on_position"
    t.index ["storytime_navigation_id"], name: "index_storytime_links_on_storytime_navigation_id"
  end

  create_table "storytime_media", id: :serial, force: :cascade do |t|
    t.string "file"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["site_id"], name: "index_storytime_media_on_site_id"
    t.index ["user_id"], name: "index_storytime_media_on_user_id"
  end

  create_table "storytime_memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "storytime_role_id"
    t.integer "site_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["site_id"], name: "index_storytime_memberships_on_site_id"
    t.index ["storytime_role_id"], name: "index_storytime_memberships_on_storytime_role_id"
    t.index ["user_id"], name: "index_storytime_memberships_on_user_id"
  end

  create_table "storytime_navigations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "handle"
    t.integer "site_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["site_id"], name: "index_storytime_navigations_on_site_id"
  end

  create_table "storytime_permissions", id: :serial, force: :cascade do |t|
    t.integer "role_id"
    t.integer "action_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["action_id"], name: "index_storytime_permissions_on_action_id"
    t.index ["role_id"], name: "index_storytime_permissions_on_role_id"
    t.index ["site_id"], name: "index_storytime_permissions_on_site_id"
  end

  create_table "storytime_posts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "type"
    t.string "title"
    t.string "slug"
    t.text "content"
    t.text "excerpt"
    t.datetime "published_at", precision: nil
    t.integer "featured_media_id"
    t.boolean "featured", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "secondary_media_id"
    t.integer "site_id"
    t.string "video_url"
    t.boolean "notifications_enabled", default: false
    t.datetime "notifications_sent_at", precision: nil
    t.integer "blog_id"
    t.index ["blog_id"], name: "index_storytime_posts_on_blog_id"
    t.index ["slug"], name: "index_storytime_posts_on_slug"
    t.index ["user_id"], name: "index_storytime_posts_on_user_id"
  end

  create_table "storytime_roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_storytime_roles_on_name"
  end

  create_table "storytime_sites", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "post_slug_style", default: 0
    t.string "ga_tracking_id"
    t.integer "root_post_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "subscription_email_from"
    t.string "layout"
    t.string "disqus_forum_shortname"
    t.integer "user_id"
    t.string "custom_domain"
    t.string "discourse_name"
    t.index ["root_post_id"], name: "index_storytime_sites_on_root_post_id"
    t.index ["user_id"], name: "index_storytime_sites_on_user_id"
  end

  create_table "storytime_snippets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["name"], name: "index_storytime_snippets_on_name"
  end

  create_table "storytime_subscriptions", id: :serial, force: :cascade do |t|
    t.string "email"
    t.boolean "subscribed", default: true
    t.string "token"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["token"], name: "index_storytime_subscriptions_on_token"
  end

  create_table "storytime_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "post_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["post_id"], name: "index_storytime_taggings_on_post_id"
    t.index ["site_id"], name: "index_storytime_taggings_on_site_id"
    t.index ["tag_id"], name: "index_storytime_taggings_on_tag_id"
  end

  create_table "storytime_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
  end

  create_table "storytime_versions", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.string "versionable_type"
    t.integer "versionable_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "site_id"
    t.index ["site_id"], name: "index_storytime_versions_on_site_id"
    t.index ["user_id"], name: "index_storytime_versions_on_user_id"
    t.index ["versionable_type", "versionable_id"], name: "versionable_index"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "storytime_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "widgets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  add_foreign_key "storytime_links", "storytime_navigations"
end
