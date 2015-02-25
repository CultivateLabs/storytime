class AddSiteIdToStorytimePermissions < ActiveRecord::Migration
  def change
    add_column :storytime_permissions, :site_id, :integer
    add_index :storytime_permissions, :site_id

    Storytime::Permission.seed
  end
end
