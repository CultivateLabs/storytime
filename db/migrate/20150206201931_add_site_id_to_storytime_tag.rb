class AddSiteIdToStorytimeTag < ActiveRecord::Migration
  def change
    add_column :storytime_tags, :site_id, :integer

    site = Storytime::Site.first

    Storytime::Tag.all.each do |tag|
      tag.update_attributes(site_id: site.id)
    end
  end
end
