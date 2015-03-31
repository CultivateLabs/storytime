class AddSiteIdToStorytimeSnippet < ActiveRecord::Migration
  def change
    add_column :storytime_snippets, :site_id, :integer

    Storytime::Migrators::V1.add_site_id_to_snippets
  end
end
