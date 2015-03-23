class UpdateStorytimeSiteIdColumns < ActiveRecord::Migration
  def up
    Storytime::Migrators::V1.add_site_id_to_autosaves
    Storytime::Migrators::V1.add_site_id_to_comments
    Storytime::Migrators::V1.add_site_id_to_versions
    Storytime::Migrators::V1.add_site_id_to_taggings
  end

  def down
  end
end
