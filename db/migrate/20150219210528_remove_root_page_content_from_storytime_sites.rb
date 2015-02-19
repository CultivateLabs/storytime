class RemoveRootPageContentFromStorytimeSites < ActiveRecord::Migration
  def change
    remove_column :storytime_sites, :root_page_content
  end
end
