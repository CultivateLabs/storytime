module Storytime
  class Page < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    extend FriendlyId
    belongs_to Storytime.user_class_symbol
    friendly_id :title, use: [:history]

    validates_presence_of :title, :draft_content

    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
