class AddLayoutToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :layout, :string
  end
end
