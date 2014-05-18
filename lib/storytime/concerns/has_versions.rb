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
        self.versions.order(updated_at: :desc).first
      end

      def create_version
        if self.latest_version.nil? || self.draft_content != self.latest_version.content
          version = self.versions.new
          version.content = self.draft_content
          version.user_id = self.draft_user_id
          version.save
        end
        self.publish! if self.published?
      end

      def publish!
        self.update_columns(self.class.draft_content_column => self.latest_version.content, :published => true)
      end

      included do
        has_many :versions, as: :versionable, dependent: :destroy
        cattr_accessor :draft_content_column
        attr_accessor :draft_user_id
        attr_writer :draft_content
        after_save :create_version

        self.draft_content_column = :content

        scope :published, -> { where(published: true) }
      end

      module ClassMethods
        
      end
    end
  end
end