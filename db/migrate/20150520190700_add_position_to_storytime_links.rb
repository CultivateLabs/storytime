class AddPositionToStorytimeLinks < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_links, :position, :integer
    add_index :storytime_links, :position
  end
end
