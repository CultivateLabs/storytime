require "storytime/engine"

module Storytime
  # Model to use for Storytime users.
  mattr_accessor :user_class
  @@user_class = 'User'

  # Character limit for Storytime::Post.title <= 255
  mattr_accessor :post_title_character_limit
  @@post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt <= 255
  mattr_accessor :post_excerpt_character_limit
  @@post_excerpt_character_limit = 255

  # Enable file uploads through Carrierwave
  mattr_accessor :enable_file_upload
  @@enable_file_upload = true

  class << self
    attr_accessor :layout, :media_storage, :s3_bucket, :post_types
    
    def configure
      self.post_types ||= []
      yield self
    end

    def user_class
      @@user_class.constantize
    end

    def user_class_symbol
      @@user_class.underscore.to_sym
    end
  end
end
