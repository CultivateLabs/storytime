class AddPostTypeIdToPosts < ActiveRecord::Migration
  def change
    add_reference :storytime_posts, :post_type, index: true
  end
end
