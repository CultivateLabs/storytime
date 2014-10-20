class AddSecondaryMediaIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :secondary_media_id, :integer
  end
end
