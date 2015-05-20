class AddPositionToStorytimeLinks < ActiveRecord::Migration
  def change
    add_column :storytime_links, :position, :integer
    add_index :storytime_links, :position
  end
end
