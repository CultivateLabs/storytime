class AddVideoUrlToStorytimePosts < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_posts, :video_url, :string
  end
end
