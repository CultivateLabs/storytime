module Storytime
  class Blog < Page
    has_many :posts, dependent: :destroy

    def self.seed(site, user)
      blog = site.blogs.new
      blog.title = "Blog"
      blog.slug = "blog"
      blog.published_at = Time.now
      blog.user = user
      blog.save
      blog
    end
  end
end