module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    include ActionView::Helpers::SanitizeHelper

    extend FriendlyId
    friendly_id :slug_candidates, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :featured_media, class_name: "Media"
    belongs_to :secondary_media, class_name: "Media"

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    has_many :comments

    has_one :autosave, as: :autosavable, dependent: :destroy, class_name: "Autosave"

    attr_accessor :preview, :published_at_date, :published_at_time

    validates_presence_of :title, :draft_content
    validates :title, length: { in: 1..Storytime.post_title_character_limit }
    validates :excerpt, length: { in: 0..Storytime.post_excerpt_character_limit }
    validates :user, presence: true
    validates :type, inclusion: { in: Storytime.post_types }

    before_validation :populate_excerpt_from_content
    before_save :sanitize_content
    before_save :set_published_at

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
        Storytime::Tag.select("storytime_tags.*, count(storytime_taggings.tag_id) as count").joins(:taggings).group("storytime_tags.id")

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

    def tag_list=(names_or_ids)
      self.tags = names_or_ids.map do |n|
        if n.empty? || n == "nv__"
          ""
        elsif n.include?("nv__") || n.to_i == 0
          Storytime::Tag.where(name: n.sub("nv__", "").strip).first_or_create!
        else
          Storytime::Tag.find(n)
        end
      end.delete_if { |x| x == "" }
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

    def slug_candidates
      if slug.nil? then [:title] elsif slug_changed? then [:slug] end
    end

    def should_generate_new_friendly_id?
      self.slug = nil if slug == ""
      slug_changed? || (slug.nil? && published_at_changed? && published_at_change.first.nil?)
    end

    def sanitize_content
      self.draft_content = sanitize(self.draft_content, tags: Storytime.whitelisted_post_html_tags) unless Storytime.whitelisted_post_html_tags.blank?
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
  end
end