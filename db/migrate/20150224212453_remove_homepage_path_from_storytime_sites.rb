class RemoveHomepagePathFromStorytimeSites < ActiveRecord::Migration
  def change
    remove_column :storytime_sites, :homepage_path
  end
end
