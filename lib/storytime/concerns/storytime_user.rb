module Storytime
  module Concerns
    module StorytimeUser
      extend ActiveSupport::Concern

      module ClassMethods
        def storytime_user
          has_many :memberships, class_name: "Storytime::Membership"
          has_many :storytime_roles, through: :memberships
          # has_many :sites, through: :memberships, class_name: "Storytime::Site"
          
          has_many :storytime_posts, class_name: "Storytime::Post"
          has_many :storytime_pages, class_name: "Storytime::Page"
          has_many :storytime_media, class_name: "Storytime::Media"
          has_many :storytime_versions, class_name: "Storytime::Version"
          has_many :storytime_comments, class_name: "Storytime::Comment"

          accepts_nested_attributes_for :memberships

          scope :non_members, ->(site) { all.reject{|user| user.storytime_user?(site)} }

          class_eval <<-EOS
            def self.policy_class
              UserPolicy
            end

            def storytime_user?
              storytime_role.present?
            end

            def storytime_user?(site)
              Storytime::Membership.unscoped.find_by(site: site, user: self).present?
            end

            def storytime_role
              current_membership.storytime_role if current_membership
            end

            def current_membership
              Storytime::Membership.unscoped.find_by(site: Storytime::Site.find(Storytime::Site.current_id), user: self)
            end

            def sites
              Storytime::Site.where(id: Storytime::Membership.unscoped.where(user: self).map(&:site_id))
            end
          EOS

          %w{admin editor writer}.each do |role_name|
            class_eval <<-EOS
              def storytime_#{role_name}?(site)
                current_membership && current_membership.storytime_role.name == "#{role_name}"
              end
            EOS
          end  
        end
      end

    end
  end
end

ActiveRecord::Base.send :include, Storytime::Concerns::StorytimeUser
