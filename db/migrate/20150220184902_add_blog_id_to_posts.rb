class AddBlogIdToPosts < ActiveRecord::Migration
  def change
    add_column :storytime_posts, :blog_id, :integer
    add_index :storytime_posts, :blog_id

    Storytime::Site.find_each do |site|
      default_blog = site.blogs.first
      # TRANSFER POSTS IN PRIMARY FEED TO DEFAULT BLOG
      Storytime::Post.primary_feed_types.each do |type|
        type.all.find_each do |post|
          post.blog = default_blog
          post.save
        end
      end

      # CREATE ANOTHER BLOG FOR ALL POST TYPES NOT IN PRIMARY FEED
      Storytime.post_types.reject{|type| ["Storytime::Page", "Storytime::Blog"].include?(type) || type.constantize.included_in_primary_feed? }.each do |type|
        blog = site.blogs.new
        blog.published_at = Time.now
        blog.title = type.split("::").last.titleize.pluralize
        blog.draft_content = "Test"
        blog.slug = type.split("::").last.tableize.gsub("_", "-")
        blog.user = Storytime.user_class.first
        blog.save

        # TRANSFER POSTS NOT IN PRIMARY FEED TO DEFAULT BLOG
        type.constantize.all.find_each do |post|
          post.blog = blog
          post.save
        end
      end
    end
  end
end
