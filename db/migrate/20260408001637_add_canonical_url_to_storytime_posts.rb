class AddCanonicalUrlToStorytimePosts < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_posts, :canonical_url, :string
  end
end
