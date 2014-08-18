module Storytime
  class PostType < ActiveRecord::Base
    has_many :posts
    has_many :custom_fields

    validates :name, uniqueness: true

    scope :excluded_from_primary_feed, ->{ where(excluded_from_primary_feed: true) }
    scope :included_in_primary_feed, ->{ where(excluded_from_primary_feed: false) }

    accepts_nested_attributes_for :custom_fields, allow_destroy: true

    DEFAULT_TYPE_NAME = "blog"
    STATIC_PAGE_TYPE_NAME = "page"

    def self.default_type
      find_or_create_by(name: DEFAULT_TYPE_NAME, permanent: true)
    end

    def self.static_page_type
      find_or_create_by(name: STATIC_PAGE_TYPE_NAME, permanent: true, excluded_from_primary_feed: true)
    end

    def self.seed
      default_type
      static_page_type
    end

    def self.primary_feed_type_ids
      included_in_primary_feed.pluck(:id)
    end
  end
end
