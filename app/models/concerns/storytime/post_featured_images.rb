module Storytime::PostFeaturedImages
  extend ActiveSupport::Concern

  included do
    belongs_to :featured_media, class_name: "Storytime::Media"
    belongs_to :secondary_media, class_name: "Storytime::Media"
  end
end