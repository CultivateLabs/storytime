module Storytime::CustomPostType
  extend ActiveSupport::Concern

  included do
    include Storytime::BlogPostPartialInheritance
    include Storytime::PostComments
    include Storytime::PostExcerpt
    include Storytime::PostFeaturedImages
  end
end