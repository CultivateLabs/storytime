module Storytime
  class Comment < ActiveRecord::Base
    belongs_to Storytime.user_class_symbol
    belongs_to :post

    validates Storytime.user_class_symbol, presence: true
    validates :post_id, presence: true

    def commenter_name
      user.nil? ? "" : (user.storytime_name || user.email)
    end
  end
end
