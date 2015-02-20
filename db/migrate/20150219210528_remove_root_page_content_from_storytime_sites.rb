class RemoveRootPageContentFromStorytimeSites < ActiveRecord::Migration
  def up
    Storytime::Site.find_each do |site|
      blog = site.blogs.new
      blog.published_at = Time.now
      blog.title = "Blog"
      blog.draft_content = "Test"
      blog.slug = "blog"
      blog.user = Storytime.user_class.first
      blog.save
      if site.root_page_content == 0 
        site.homepage = blog
        site.save
      end
    end

    remove_column :storytime_sites, :root_page_content
  end

  def down
    Storytime::Blog.destroy_all
    add_column :storytime_sites, :root_page_content, :integer, default: 0
  end
end
