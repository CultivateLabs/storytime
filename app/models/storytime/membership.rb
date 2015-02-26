module Storytime
  class Membership < ActiveRecord::Base
    include Storytime::ScopedToSite
    belongs_to :user, class_name: Storytime.user_class
    belongs_to :storytime_role, class_name: "Storytime::Role"
    belongs_to :site, class_name: "Storytime::Site"

    validates :storytime_role, :user, presence: true
  end
end