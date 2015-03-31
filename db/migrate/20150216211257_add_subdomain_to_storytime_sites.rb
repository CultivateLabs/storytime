class AddSubdomainToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :subdomain, :string
  end
end
