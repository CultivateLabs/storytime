class AddSiteIdToStorytimeMedia < ActiveRecord::Migration[4.2]
  def up
    Storytime::Migrators::V1.add_site_id_to_media
  end

  def down
  end
end
