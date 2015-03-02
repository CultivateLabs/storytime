class AddSiteIdToStorytimeMedia < ActiveRecord::Migration
  def up
    Storytime::Migrators::V1.add_site_id_to_snippets
  end

  def down
  end
end
