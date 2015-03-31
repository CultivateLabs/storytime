module Storytime
  module Concerns
    module StorytimeUser
      extend ActiveSupport::Concern

      module ClassMethods
        def storytime_user
          has_many :storytime_memberships, class_name: "::Storytime::Membership", dependent: :destroy
          has_many :storytime_roles, through: :storytime_memberships
          has_many :storytime_sites, through: :storytime_memberships, source: :site
          
          has_many :storytime_posts, class_name: "Storytime::Post"
          has_many :storytime_pages, class_name: "Storytime::Page"
          has_many :storytime_media, class_name: "Storytime::Media"
          has_many :storytime_versions, class_name: "Storytime::Version"
          has_many :storytime_comments, class_name: "Storytime::Comment"

          accepts_nested_attributes_for :storytime_memberships, allow_destroy: true

          scope :non_members, ->(site) { all.reject{|user| user.storytime_user?(site)} }

          include Storytime::Concerns::StorytimeUser::LocalInstanceMethods

          class_eval <<-EOS
            def self.policy_class
              UserPolicy
            end
          EOS

          %w{admin editor writer}.each do |role_name|
            class_eval <<-EOS
              def storytime_#{role_name}?(site)
                role = storytime_role_in_site(site)
                role && role.name == "#{role_name}"
              end
            EOS
          end  
        end
      end

      module LocalInstanceMethods
        def storytime_name
          self[:storytime_name] || email
        end

        def storytime_user?(site)
          storytime_memberships.find_by(site: site).present?
        end

        def storytime_role_in_site(site)
          if membership = storytime_membership_in_site(site)
            membership.storytime_role
          end
        end

        def storytime_membership_in_site(site)
          storytime_memberships.find_by(site: site)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Storytime::Concerns::StorytimeUser
