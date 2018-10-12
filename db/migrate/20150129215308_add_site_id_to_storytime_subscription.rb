class AddSiteIdToStorytimeSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_subscriptions, :site_id, :integer
  end
end
