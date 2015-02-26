class AddSiteIdToStorytimeTag < ActiveRecord::Migration
  def change
    add_column :storytime_tags, :site_id, :integer

    Storytime::Migrators::V1.add_site_id_to_tags
  end
end
