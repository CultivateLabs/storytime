class RemoveSubdomainFromStorytimeSite < ActiveRecord::Migration
  def change
    remove_column :storytime_sites, :subdomain, :string
  end
end
