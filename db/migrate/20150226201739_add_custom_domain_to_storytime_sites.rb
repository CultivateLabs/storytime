class AddCustomDomainToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :custom_domain, :string
  end
end
