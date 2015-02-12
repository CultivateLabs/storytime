module Storytime
  class Comment < ActiveRecord::Base
    belongs_to :user, class_name: Storytime.user_class
    belongs_to :post

    validates :user, presence: true
    validates :post_id, presence: true

    def commenter_name
      user.nil? ? "" : (user.storytime_name || user.email)
    end
  end
end
