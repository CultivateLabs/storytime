class AddPostTypeIdToPages < ActiveRecord::Migration
  def change
    add_reference :storytime_pages, :post_type, index: true
  end
end
