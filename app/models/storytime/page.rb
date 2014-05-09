module Storytime
  class Page < ActiveRecord::Base
    belongs_to :user

    validates_presence_of :title, :content
    before_save :set_slug

  private
    def set_slug
      slug = title.parameterize
    end
  end
end
