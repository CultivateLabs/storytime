class AddSubscriptionEmailFromToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :subscription_email_from, :string
  end
end
