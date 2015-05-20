module Storytime
  class Link < ActiveRecord::Base
    belongs_to :navigation, class_name: "Storytime::Navigation"
    belongs_to :linkable, polymorphic: true
  end
end
