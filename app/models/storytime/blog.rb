module Storytime
  class Blog < Page
    has_many :posts

    def self.seed(site, user)
      blog = site.blogs.new
      blog.title = "Blog"
      blog.slug = "blog"
      blog.draft_content = "test"
      blog.published_at = Time.now
      blog.user = user
      blog.save
    end

    def show_comments?
      false
    end

    def self.included_in_primary_feed?
      false
    end
  end
end