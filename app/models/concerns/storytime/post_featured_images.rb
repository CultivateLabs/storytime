module Storytime::PostFeaturedImages
  extend ActiveSupport::Concern

  included do
    belongs_to :featured_media, class_name: "Storytime::Media", optional: true
    belongs_to :secondary_media, class_name: "Storytime::Media", optional: true
  end
end