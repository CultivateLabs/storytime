class AddUrlToStorytimeLinks < ActiveRecord::Migration
  def change
    add_column :storytime_links, :url, :string
  end
end
