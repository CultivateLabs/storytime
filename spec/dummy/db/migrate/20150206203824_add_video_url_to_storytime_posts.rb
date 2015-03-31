class AddVideoUrlToStorytimePosts < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :video_url, :string
  end
end
