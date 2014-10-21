class AddSecondaryMediaIdToPost < ActiveRecord::Migration
  def change
    add_reference :storytime_posts, :secondary_media
  end
end
