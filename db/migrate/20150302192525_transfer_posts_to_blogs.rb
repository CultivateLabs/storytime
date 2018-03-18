class TransferPostsToBlogs < ActiveRecord::Migration[4.2]
  def up
    Storytime::Migrators::V1.transfer_posts_to_blogs
  end

  def down
  end
end
