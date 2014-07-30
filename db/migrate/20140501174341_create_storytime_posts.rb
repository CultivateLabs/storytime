class CreateStorytimePosts < ActiveRecord::Migration
  def change
    create_table :storytime_posts do |t|
      t.references :user, index: true
      t.string :title
      t.string :slug, index: true
      t.text :content
      t.text :excerpt
      t.datetime :published_at
      t.references :post_type, index: true
      t.references :featured_media

      t.timestamps
    end
  end
end
