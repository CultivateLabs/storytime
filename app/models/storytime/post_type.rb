module Storytime
  class PostType < ActiveRecord::Base
    has_many :posts
    has_many :pages
  end
end
