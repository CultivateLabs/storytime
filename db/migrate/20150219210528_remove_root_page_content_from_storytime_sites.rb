class RemoveRootPageContentFromStorytimeSites < ActiveRecord::Migration
  def up
    Storytime::Migrators::V1.create_default_blog_for_sites

    remove_column :storytime_sites, :root_page_content
  end

  def down
    Storytime::Blog.destroy_all
    add_column :storytime_sites, :root_page_content, :integer, default: 0
  end
end
