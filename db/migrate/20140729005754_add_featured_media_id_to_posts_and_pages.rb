class AddFeaturedMediaIdToPostsAndPages < ActiveRecord::Migration
  def change
    add_reference :storytime_posts, :featured_media
    add_reference :storytime_pages, :featured_media
  end
end
