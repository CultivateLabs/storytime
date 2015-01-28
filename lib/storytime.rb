require "storytime/engine"

module Storytime
  # Model to use for Storytime users.
  mattr_accessor :user_class
  @@user_class = 'User'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  mattr_accessor :dashboard_namespace_path
  @@dashboard_namespace_path = "/storytime"

  # Path of Storytime's home page, relative to
  # Storytime's mount point within the host app.
  mattr_accessor :home_page_path
  @@home_page_path = "/"

  # Enable file uploads through Carrierwave.
  mattr_accessor :enable_file_upload
  @@enable_file_upload = true

  # Character limit for Storytime::Post.title <= 255
  mattr_accessor :post_title_character_limit
  @@post_title_character_limit = 255

  # Character limit for Storytime::Post.excerpt
  mattr_accessor :post_excerpt_character_limit
  @@post_excerpt_character_limit = 500

  # Array of tags to allow from the Summernote WYSIWYG
  # Editor when editing Posts and custom post types.
  # An empty array, "", or nil setting will permit all tags.
  mattr_accessor :whitelisted_post_html_tags
  @@whitelisted_post_html_tags = []

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  mattr_accessor :disqus_forum_shortname
  @@disqus_forum_shortname = ""

  mattr_accessor :admin_models
  @@admin_models = []

  class << self
    attr_accessor :layout, :media_storage, :s3_bucket, :post_types
    
    def configure
      self.post_types ||= []

      yield self
    end

    def user_class
      @@user_class.constantize
    end

    def user_class_underscore
      @@user_class.to_s.underscore
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
