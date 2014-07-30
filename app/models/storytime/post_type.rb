module Storytime
  class PostType < ActiveRecord::Base
    has_many :posts

    DEFAULT_TYPE_NAME = "blog"

    def self.seed
      find_or_create_by(name: DEFAULT_TYPE_NAME, permanent: true)
      find_or_create_by(name: "page", permanent: true)
    end
  end
end
