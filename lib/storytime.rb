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

  # Enable file uploads through Carrierwave.
  mattr_accessor :enable_file_upload
  @@enable_file_upload = true

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  mattr_accessor :dashboard_namespace_path
  @@dashboard_namespace_path = "/storytime"

  # Path of Storytime's home page, relative to
  # Storytime's mount point within the host app.
  mattr_accessor :home_page_path
  @@home_page_path = "/"

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

    def snippet(name)
      snippet = Storytime::Snippet.find_by(name: name)
      snippet.nil? ? "" : snippet.content.html_safe
    end
  end
end
