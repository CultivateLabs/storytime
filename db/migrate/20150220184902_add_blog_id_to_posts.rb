class AddBlogIdToPosts < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :blog_id, :integer
    add_index :storytime_posts, :blog_id

    Storytime::Migrators::V1.transfer_posts_to_blogs
  end
end
