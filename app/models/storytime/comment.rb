module Storytime
  class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :post

    validates :user_id, presence: true
    validates :post_id, presence: true

    def commenter_name
      user.nil? ? "" : (user.storytime_name || user.email)
    end
  end
end
