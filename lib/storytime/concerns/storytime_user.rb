module Storytime
  module Concerns
    module StorytimeUser
      extend ActiveSupport::Concern

      module ClassMethods
        def storytime_user
          belongs_to :storytime_role, class_name: "Storytime::Role"
          has_many :storytime_posts, class_name: "Storytime::Post"
          has_many :storytime_pages, class_name: "Storytime::Page"
          has_many :storytime_media, class_name: "Storytime::Media"
          has_many :storytime_versions, class_name: "Storytime::Version"
        end
      end

    end
  end
end

ActiveRecord::Base.send :include, Storytime::Concerns::StorytimeUser
