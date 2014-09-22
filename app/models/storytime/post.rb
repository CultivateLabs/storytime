module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions

    extend FriendlyId
    friendly_id :title, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :featured_media, class_name: "Media"

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    has_many :comments

    has_one :autosave, as: :autosavable, dependent: :destroy, class_name: "Autosave"

    attr_accessor :preview

    validates_presence_of :title, :excerpt, :draft_content
    validates :title, length: { in: 1..200 }
    validates :excerpt, length: { in: 1..400 }
    validates :user, presence: true
    validates :type, inclusion: { in: Storytime.post_types }

    before_validation :populate_excerpt_from_content

    scope :primary_feed, ->{ where(type: primary_feed_types) }

    def self.policy_class
      Storytime::PostPolicy
    end

    def self.primary_feed_types
      Storytime.post_types.map{|post_type| post_type.constantize }.select do |post_type|
        post_type.included_in_primary_feed?
      end
    end

    def self.human_name
      @human_name ||= type_name.humanize.split(" ").map(&:capitalize).join(" ")
    end

    def self.find_preview(id)
      Post.friendly.find(id)
    end

    def human_name
      self.class.human_name
    end

    def self.type_name
      to_s.split("::").last.underscore
    end

    def type_name
      self.class.type_name
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

    def self.included_in_primary_feed?
      true
    end

    def included_in_primary_feed?
      self.class.included_in_primary_feed
    end

    def author_name
      user.storytime_name.blank? ? user.email : user.storytime_name
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, "Post")
    end
  end
end