class AddHomepagePathToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :homepage_path, :string
  end
end
