class RemoveSubdomainFromStorytimeSite < ActiveRecord::Migration[4.2]
  def change
    remove_column :storytime_sites, :subdomain, :string
  end
end
