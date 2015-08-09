module Storytime
  class Link < ActiveRecord::Base
    belongs_to :navigation, class_name: "Storytime::Navigation"
    belongs_to :linkable, polymorphic: true

    acts_as_list scope: :storytime_navigation_id

    default_scope { order(:position) }

    validates_presence_of :text
    validates_presence_of :url, if: Proc.new {|link| link.linkable.blank? }
    validates_presence_of :linkable, if: Proc.new {|link| link.url.blank? }
    
    before_save :ensure_protocol_for_external_links
    
    def ensure_protocol_for_external_links
      if linkable.blank? && url.present? && !url.include?("://")
        self.url = "http://#{url}"
      end
    end
  end
end