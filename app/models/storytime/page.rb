module Storytime
  class Page < ActiveRecord::Base
    include Storytime::Concerns::HasVersions
    extend FriendlyId
    friendly_id :title, use: [:history]

    belongs_to Storytime.user_class_symbol
    belongs_to :post_type

    validates_presence_of :title, :draft_content

    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
