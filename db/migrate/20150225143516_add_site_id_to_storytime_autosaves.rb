class AddSiteIdToStorytimeAutosaves < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_autosaves, :site_id, :integer
    add_index :storytime_autosaves, :site_id
  end
end
