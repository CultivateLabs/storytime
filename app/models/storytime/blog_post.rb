module Storytime
  class BlogPost < Post
    include Storytime::PostComments
    include Storytime::PostExcerpt
    include Storytime::PostFeaturedImages
    include Storytime::BlogPostPartialInheritance
    belongs_to :blog, class_name: "Storytime::Blog"

    def to_partial_path
      self.class._to_partial_path(site)
    end

  end
end