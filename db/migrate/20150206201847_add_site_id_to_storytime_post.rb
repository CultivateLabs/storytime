class AddSiteIdToStorytimePost < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_posts, :site_id, :integer

    Storytime::Migrators::V1.add_site_id_to_posts
  end
end
