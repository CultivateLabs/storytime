class AddSiteIdToStorytimeComments < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_comments, :site_id, :integer
    add_index :storytime_comments, :site_id
  end
end
