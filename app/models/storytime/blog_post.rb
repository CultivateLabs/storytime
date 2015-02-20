module Storytime
  class BlogPost < Post
    include Storytime::PostComments
    include Storytime::PostExcerpt
    include Storytime::PostFeaturedImages
    belongs_to :blog
  end
end