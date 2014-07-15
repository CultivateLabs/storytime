module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions

    belongs_to Storytime.user_class_symbol
    belongs_to :post_type
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    validates_presence_of :title, :excerpt, :draft_content
    validates :title, length: { in: 1..200 }
    validates :excerpt, length: { in: 1..200 }

    def self.tagged_with(name)
      Tag.find_by_name!(name).posts
    end

    def self.tag_counts
      Tag.select("storytime_tags.*, count(storytime_taggings.tag_id) as count").joins(:taggings).group("storytime_tags.id")

      #Tagging.group("storytime_taggings.tag_id").includes(:tag)
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