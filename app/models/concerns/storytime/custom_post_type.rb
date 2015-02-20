module Storytime::CustomPostType
  extend ActiveSupport::Concern

  included do
    include Storytime::BlogPostPartialInheritance
    include Storytime::PostComments
    include Storytime::PostExcerpt
    include Storytime::PostFeaturedImages
    belongs_to :blog
  end
end