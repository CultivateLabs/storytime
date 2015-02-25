module Storytime
  class Membership < ActiveRecord::Base
    belongs_to :user, class_name: Storytime.user_class
    belongs_to :storytime_role, class_name: "Storytime::Role"
    belongs_to :site, class_name: "Storytime::Site"
  end
end