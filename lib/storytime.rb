require "storytime/engine"

module Storytime
  # Model used for the user_class in Storytime
  mattr_accessor :user_class
  @@user_class = 'User'

  # Character limit for Storytime::Post.title
  mattr_accessor :post_title_character_limit
  @@post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt
  mattr_accessor :post_excerpt_character_limit
  @@post_excerpt_character_limit = 255

  class << self
    attr_accessor :layout, :media_storage, :s3_bucket, :post_types
    
    def configure
      self.post_types ||= []
      yield self
    end

    def user_class_symbol
      user_class.to_s.underscore.to_sym
    end
  end
end
