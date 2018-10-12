class AddSiteIdToStorytimeVersions < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_versions, :site_id, :integer
    add_index :storytime_versions, :site_id
  end
end