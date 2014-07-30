module Storytime
  class PostType < ActiveRecord::Base
    has_many :posts

    validates :name, uniqueness: true

    DEFAULT_TYPE_NAME = "blog"

    def self.default_type
      find_or_create_by(name: DEFAULT_TYPE_NAME, permanent: true)
    end

    def self.seed
      find_or_create_by(name: DEFAULT_TYPE_NAME, permanent: true)
      find_or_create_by(name: "page", permanent: true)
    end
  end
end
