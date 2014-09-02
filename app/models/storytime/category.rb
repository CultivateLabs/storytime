module Storytime
  class Category < ActiveRecord::Base
    has_many :posts

    validates :name, uniqueness: true

    scope :excluded_from_primary_feed, ->{ where(excluded_from_primary_feed: true) }
    scope :included_in_primary_feed, ->{ where(excluded_from_primary_feed: false) }

    def self.primary_feed_category_ids
      included_in_primary_feed.pluck(:id)
    end
  end
end
