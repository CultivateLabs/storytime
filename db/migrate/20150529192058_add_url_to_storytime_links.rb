class AddUrlToStorytimeLinks < ActiveRecord::Migration[4.2]
  def change
    add_column :storytime_links, :url, :string
  end
end
