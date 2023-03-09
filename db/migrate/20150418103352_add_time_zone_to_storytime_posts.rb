class AddTimeZoneToStorytimePosts < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :time_zone, :string
  end
end
