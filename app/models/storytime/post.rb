module Storytime
  class Post < ActiveRecord::Base
    belongs_to :user

    validates :title, length: { in: 1..200 }
    validates :content, length: { in: 1..200 }
  end
end
