class AddSiteIdToStorytimeSubscription < ActiveRecord::Migration
  def change
    add_column :storytime_subscriptions, :site_id, :integer
  end
end
