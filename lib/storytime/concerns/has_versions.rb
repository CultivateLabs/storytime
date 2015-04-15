module Storytime
  module Concerns
    module HasVersions
      extend ActiveSupport::Concern
      
      # TO USE IN MODEL:
      # include Storytime::Concerns::HasVersions
      # self.draft_content_column = :html (defaults to :content)
      # in controller, add @post.draft_user_id = current_user.id to #create and #update

      def draft_content
        @draft_content || (self.latest_version.present? ? self.latest_version.content : "")
      end

      def latest_version
        # @latest_version ||= self.versions.order(updated_at: :desc, id: :desc).first
        self.versions.order(updated_at: :desc).first
      end

      def create_version
        unless self.draft_content.blank?
          if self.latest_version.nil? || self.draft_content != self.latest_version.content
            version = self.versions.new
            version.content = self.draft_content
            version.user_id = self.draft_user_id
            version.save
          end
        end
        self.publish! if self.published?
      end

      def activate_version
        if @draft_version_id
          version = Storytime::Version.find(@draft_version_id)
          if self.update_columns(self.class.draft_content_column => version.content)
            version.touch
          end
        end
      end

      def publish!
        self.published = "1"
        attrs = {self.class.draft_content_column => (self.latest_version.present? ? self.latest_version.content : "") }
        self.update_columns(attrs)
      end

      def published=(val)
        if val == "1" || val == "true" || val == true
          if self.published_at_date || self.published_at_time
            self.published_at = if self.published_at_time.nil?
              DateTime.parse "#{self.published_at_date}"
            elsif self.published_at_date.nil?
              DateTime.parse "#{Date.today} #{self.published_at_time}"
            else
              DateTime.parse "#{self.published_at_date} #{self.published_at_time}"
            end
          else
            self.published_at = Time.now unless self.published_at
          end
        else
          self.published_at_date = nil
          self.published_at_time = nil
        end
      end

      def published
        !published_at.nil?
      end

      def published?
        published
      end

      included do
        has_many :versions, as: :versionable, dependent: :destroy
        cattr_accessor :draft_content_column
        attr_accessor :draft_user_id, :published_at_date, :published_at_time
        attr_writer :draft_content, :draft_version_id
        after_save :create_version, :activate_version

        self.draft_content_column = :content

        scope :published, -> { where("published_at IS NOT NULL").where("published_at <= ?", Time.now) }
        scope :draft, -> { where("published_at IS NULL OR published_at > ?", Time.now) }
      end

      module ClassMethods
        
      end
    end
  end
end