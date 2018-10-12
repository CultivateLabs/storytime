class AddSiteToStorytimeMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_media, :site_id, :integer
    add_index :storytime_media, :site_id
  end
end
