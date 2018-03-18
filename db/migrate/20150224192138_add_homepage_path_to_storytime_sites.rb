class AddHomepagePathToStorytimeSites < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_sites, :homepage_path, :string
  end
end
