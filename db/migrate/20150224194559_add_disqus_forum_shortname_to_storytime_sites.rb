class AddDisqusForumShortnameToStorytimeSites < ActiveRecord::Migration
  def change
    add_column :storytime_sites, :disqus_forum_shortname, :string
  end
end
