module Storytime
  class Comment < ActiveRecord::Base
    include Storytime::ScopedToSite

    belongs_to :user, class_name: Storytime.user_class
    belongs_to :post
    belongs_to :site

    validates :user, presence: true
    validates :post_id, presence: true

    def commenter_name
      user.nil? ? "" : user.storytime_name
    end
  end
end
