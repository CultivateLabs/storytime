class AddSiteIdToStorytimeTag < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_tags, :site_id, :integer

    Storytime::Migrators::V1.add_site_id_to_tags
  end
end
