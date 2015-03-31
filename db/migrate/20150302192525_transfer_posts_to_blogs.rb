class TransferPostsToBlogs < ActiveRecord::Migration
  def up
    Storytime::Migrators::V1.transfer_posts_to_blogs
  end

  def down
  end
end
