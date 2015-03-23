class AddSiteIdToStorytimePost < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :site_id, :integer

    Storytime::Migrators::V1.add_site_id_to_posts
  end
end
