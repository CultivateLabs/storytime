# This migration comes from storytime (originally 20140501174341)
class CreateStorytimePosts < ActiveRecord::Migration
  def change
    create_table :storytime_posts do |t|
      t.references :user, index: true
      t.string :type
      t.string :title
      t.string :slug, index: true
      t.text :content
      t.text :excerpt
      t.datetime :published_at
      t.references :featured_media
      t.boolean :featured, default: false

      t.timestamps
    end
  end
end
