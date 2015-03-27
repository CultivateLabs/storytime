module Storytime
  class Membership < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :user, class_name: Storytime.user_class
    belongs_to :storytime_role, class_name: "Storytime::Role"
    belongs_to :site, class_name: "Storytime::Site"

    validates :storytime_role, :user, presence: true
    validates_uniqueness_of :user_id, scope: :site_id

    delegate :storytime_name, to: :user, allow_nil: true

    def self.all_for_user(user)
      unscoped.where(user: user).includes(:site).where.not(site_id: nil)
    end
  end
end