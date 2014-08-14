class AddExcludedFromPrimaryFeedToPostTypes < ActiveRecord::Migration
  def up
    add_column :storytime_post_types, :excluded_from_primary_feed, :boolean, default: false
    Storytime::PostType.find_by(name: Storytime::PostType::STATIC_PAGE_TYPE_NAME).update_attribute(:excluded_from_primary_feed, true)
  end

  def down
    remove_column :storytime_post_types, :excluded_from_primary_feed
  end
end
