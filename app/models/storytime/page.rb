module Storytime
  class Page < ActiveRecord::Base
    extend FriendlyId
    belongs_to :user
    friendly_id :title, use: [:history]

    validates_presence_of :title, :content

    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
