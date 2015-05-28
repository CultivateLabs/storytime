module Storytime
  class Link < ActiveRecord::Base
    belongs_to :navigation, class_name: "Storytime::Navigation"
    belongs_to :linkable, polymorphic: true

    acts_as_list scope: :storytime_navigation_id

    default_scope { order(:position) }

    validates_presence_of :text
  end
end