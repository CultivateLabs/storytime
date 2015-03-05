module Storytime
  class Post < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    include ActionView::Helpers::SanitizeHelper
    include Storytime::ScopedToSite
    include Storytime::PostTags

    extend FriendlyId
    friendly_id :slug_candidates, use: [:history, :scoped], scope: :site

    belongs_to :user, class_name: Storytime.user_class
    belongs_to :site

    has_one :autosave, as: :autosavable, dependent: :destroy, class_name: "Autosave"

    attr_accessor :preview

    validates_presence_of :title
    validates :title, length: { in: 1..Storytime.post_title_character_limit }
    validates :user, presence: true
    validates :type, inclusion: { in: Storytime.post_types }

    before_save :sanitize_content

    scope :primary_feed, ->{ where(type: primary_feed_types) }
    scope :notification_delivery_pending, -> { where(notifications_enabled: true, notifications_sent_at: nil) }

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
        post = Post.friendly.find(id)
        
        if post.present?
          post.content = post.preview_content
          post.preview = true
        end

        post
      end

      def type_name
        to_s.split("::").last.underscore
      end

      def included_in_primary_feed?
        true
      end
    end 
    #### END class << self

    def preview_content
      autosave.present? ? autosave.content : latest_version.content 
    end

    def human_name
      self.class.human_name
    end

    def type_name
      self.class.type_name
    end

    def included_in_primary_feed?
      self.class.included_in_primary_feed
    end

    def author_name
      user.storytime_name.blank? ? user.email : user.storytime_name
    end

    def slug_candidates
      if slug.blank? then [:title] elsif slug_changed? then [:slug] end
    end

    def should_generate_new_friendly_id?
      slug = nil if slug == ""
      slug_changed? || (slug.nil? && published_at_changed? && published_at_change.first.nil?)
    end

    def sanitize_content
      self.draft_content = Storytime.post_sanitizer.call(self.draft_content) unless Storytime.post_sanitizer.blank?
    end

  end
end