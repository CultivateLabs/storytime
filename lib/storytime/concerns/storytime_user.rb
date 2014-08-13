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
          has_many :storytime_comments, class_name: "Storytime::Comment"

          class_eval <<-EOS
            def storytime_user?
              !storytime_role.nil?
            end
          EOS

          %w{admin editor writer}.each do |role_name|
            class_eval <<-EOS
              def storytime_#{role_name}?
                storytime_role && storytime_role.name == "#{role_name}"
              end
            EOS
          end  
        end
      end

    end
  end
end

ActiveRecord::Base.send :include, Storytime::Concerns::StorytimeUser
