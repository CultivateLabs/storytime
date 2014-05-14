module Storytime
  class Tagging < ActiveRecord::Base
    belongs_to :tag
    belongs_to :post

    after_destroy :remove_unused_tags

  private
    def remove_unused_tags
      tag.destroy if tag.taggings.count == 0
    end
  end
end
