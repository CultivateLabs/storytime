module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    include ActionView::Helpers::SanitizeHelper

    extend FriendlyId
    friendly_id :title, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :featured_media, class_name: "Media"

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    has_many :comments

    has_one :autosave, as: :autosavable, dependent: :destroy, class_name: "Autosave"

    attr_accessor :preview, :published_at_date, :published_at_time

    validates_presence_of :title, :excerpt, :draft_content
    validates :title, length: { in: 1..255 }
    validates :excerpt, length: { in: 1..600 }
    validates :user, presence: true
    validates :type, inclusion: { in: Storytime.post_types }

    before_validation :populate_excerpt_from_content
    before_save :set_published_at
    before_save :regenerate_slug

    scope :primary_feed, ->{ where(type: primary_feed_types) }

    class << self
      def policy_class
        Storytime::PostPolicy
      end

      def primary_feed_types
        Storytime.post_types.map{|post_type| post_type.constantize }.select do |post_type|
          post_type.included_in_primary_feed?
        end
      end

      def human_name
        @human_name ||= type_name.humanize.split(" ").map(&:capitalize).join(" ")
      end

      def find_preview(id)
        Post.friendly.find(id)
      end

      def type_name
        to_s.split("::").last.underscore
      end

      def tagged_with(name)
        if t = Storytime::Tag.find_by(name: name)
          joins(:taggings).where(storytime_taggings: { tag_id: t.id }) 
        else
          none
        end
      end

      def tag_counts
        Tag.select("storytime_tags.*, count(storytime_taggings.tag_id) as count").joins(:taggings).group("storytime_tags.id")

        #Tagging.group("storytime_taggings.tag_id").includes(:tag)
      end

      def included_in_primary_feed?
        true
      end

      def model_name
        ActiveModel::Name.new(self, nil, "Post")
      end
    end

    def human_name
      self.class.human_name
    end

    def type_name
      self.class.type_name
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
      self.excerpt = strip_tags(self.excerpt)
    end

    def show_comments?
      true
    end

    def included_in_primary_feed?
      self.class.included_in_primary_feed
    end

    def author_name
      user.storytime_name.blank? ? user.email : user.storytime_name
    end

    def set_published_at
      if self.published_at_date || self.published_at_time
        self.published_at = if self.published_at_time.nil?
          DateTime.parse "#{self.published_at_date}"
        elsif self.published_at_date.nil?
          DateTime.parse "#{Date.today} #{self.published_at_time}"
        else
          DateTime.parse "#{self.published_at_date} #{self.published_at_time}"
        end
      end
    end

    def regenerate_slug
      binding.pry
      self.slug = nil
    end
  end
end