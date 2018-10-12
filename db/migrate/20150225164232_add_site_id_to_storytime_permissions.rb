class AddSiteIdToStorytimePermissions < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_permissions, :site_id, :integer
    add_index :storytime_permissions, :site_id
  end
end
