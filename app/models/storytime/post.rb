module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    
    extend FriendlyId
    friendly_id :title, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :post_type
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    belongs_to :featured_media, class_name: "Media"

    validates_presence_of :title, :excerpt, :draft_content, :post_type_id
    validates :title, length: { in: 1..200 }
    validates :excerpt, length: { in: 1..400 }

    before_validation :populate_excerpt_from_content

    scope :page_posts, ->{ where(post_type_id: Storytime::PostType.find_by(name: "page")) }
    scope :blog_posts, ->{ where(post_type_id: Storytime::PostType.default_type.id) }
    scope :non_blog_posts, ->{ where('storytime_posts.post_type_id != ?', Storytime::PostType.default_type.id) }

    def self.tagged_with(name)
      if t = Storytime::Tag.find_by(name: name)
        joins(:taggings).where(storytime_taggings: { tag_id: t.id }) 
      else
        none
      end
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

    def populate_excerpt_from_content
      self.excerpt = (content || draft_content).slice(0..300) if excerpt.blank?
    end
  end
end