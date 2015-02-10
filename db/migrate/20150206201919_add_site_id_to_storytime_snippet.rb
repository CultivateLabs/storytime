class AddSiteIdToStorytimeSnippet < ActiveRecord::Migration
  def change
    add_column :storytime_snippets, :site_id, :integer

    site = Storytime::Site.first

    Storytime::Snippet.all.each do |snippet|
      snippet.update_attributes(site_id: site.id)
    end
  end
end
