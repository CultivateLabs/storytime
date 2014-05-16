module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    # self.draft_content_column = :html

    belongs_to :user
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    validates :title, length: { in: 1..200 }
    validates :excerpt, length: { in: 1..200 }

    def self.tagged_with(name)
      Tag.find_by_name!(name).posts
    end

    def self.tag_counts
      Tag.select("storytime_tags.*, count(storytime_taggings.tag_id) as count").joins(:taggings).group("storytime_taggings.tag_id")
    end

    def tag_list
      tags.map(&:name).join(", ")
    end

    def tag_list=(names)
      self.taggings.destroy_all
      self.tags = names.split(",").map do |n|
        Tag.where(name: n.strip).first_or_create!
      end
    end
  end
end