module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions

    extend FriendlyId
    friendly_id :title, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :category
    belongs_to :featured_media, class_name: "Media"

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    has_many :comments

    validates_presence_of :title, :excerpt, :draft_content
    validates :title, length: { in: 1..200 }
    validates :excerpt, length: { in: 1..400 }
    validates :user, presence: true

    before_validation :populate_excerpt_from_content

    def self.register_post_type(post_type)
      post_types << post_type unless post_types.include?(post_type)
      post_types
    end

    def self.post_types
      @post_types ||= [Storytime::Post]
    end
    validates :type, inclusion: { in: post_types }

    def type_name
      self.class.to_s.split("::").last.underscore
    end

    def self.primary_feed
      where(category_id: Storytime::Category.primary_feed_type_ids)
    end

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

    def show_comments?
      true
    end

    def included_in_primary_feed
      true
    end

    def author_name
      user.storytime_name.blank? ? user.email : user.storytime_name
    end
  end
end