class AddSiteIdToStorytimePost < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :site_id, :integer

    site = Storytime::Site.first

    Storytime::Post.all.each do |post|
      post.update_attributes(site_id: site.id)
    end
  end
end
