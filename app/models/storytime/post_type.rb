module Storytime
  class PostType < ActiveRecord::Base
    has_many :posts
  end
end
