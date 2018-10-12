class AddCustomDomainToStorytimeSites < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_sites, :custom_domain, :string
  end
end
