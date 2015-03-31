class AddSiteIdToStorytimeComments < ActiveRecord::Migration
  def change
    add_column :storytime_comments, :site_id, :integer
    add_index :storytime_comments, :site_id
  end
end
