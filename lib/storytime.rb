require 'rails'
require 'storytime/engine'

module Storytime
  autoload :MysqlSearchAdapter,         'storytime/mysql_search_adapter'
  autoload :MysqlFulltextSearchAdapter, 'storytime/mysql_fulltext_search_adapter'
  autoload :PostgresSearchAdapter,      'storytime/postgres_search_adapter'
  autoload :Sqlite3SearchAdapter,       'storytime/sqlite3_search_adapter'
  autoload :StorytimeHelpers,           'storytime/storytime_helpers'
  autoload :PostNotifier,               'storytime/post_notifier'

  # Model to use for Storytime users.
  mattr_accessor :user_class
  @@user_class = 'User'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  mattr_accessor :dashboard_namespace_path
  @@dashboard_namespace_path = '/storytime'

  # Path used to sign users in. 
  mattr_accessor :login_path
  @@login_path = '/users/sign_in'

  # Path used to sign users out. 
  mattr_accessor :logout_path
  @@logout_path = '/users/sign_out'  

  # Path used to register a new user. 
  mattr_accessor :registration_path
  @@registration_path = "/users/sign_up"

  # Method used for Storytime user logout path.
  mattr_accessor :logout_method
  @@logout_method = :delete

  # Enable file uploads through Carrierwave.
  mattr_accessor :enable_file_upload
  @@enable_file_upload = true

  # Character limit for Storytime::Post.title <= 100
  mattr_accessor :post_title_character_limit
  @@post_title_character_limit = 100

  # Character limit for Storytime::Post.excerpt
  mattr_accessor :post_excerpt_character_limit
  @@post_excerpt_character_limit = 500

  # Hook for handling post content sanitization.
  # Accepts either a Lambda or Proc which can be used to
  # handle how post content is sanitized (i.e. which tags,
  # HTML attributes to allow/disallow.
  mattr_accessor :post_sanitizer
  @@post_sanitizer = Proc.new do |draft_content|
    if Rails::VERSION::MINOR <= 1
      white_list_sanitizer = HTML::WhiteListSanitizer.new
      tags = white_list_sanitizer.allowed_tags
      attributes = white_list_sanitizer.allowed_attributes
    else
      white_list_sanitizer = Rails::Html::WhiteListSanitizer.new
      tags = Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS_WITH_LIBXML2
      attributes = Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES
    end
    
    attributes << "style"

    white_list_sanitizer.sanitize(draft_content, tags: tags, attributes: attributes)
  end

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  mattr_accessor :disqus_forum_shortname
  @@disqus_forum_shortname = ""

  # Enable Discourse comments using your discourse server,
  # Your discourse server must be configured for embedded comments.
  # NOTE:  include the '/' suffix at the end of the url
  # e.g. config.discourse_name = "http://forum.example.com"
  mattr_accessor :discourse_name
  @@discourse_name = ""

  # Email regex used to validate email format validity for subscriptions.
  mattr_accessor :email_regexp
  @@email_regexp = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  # Hook for handling notification delivery when publishing content.
  # Accepts either a Lambda or Proc which can be setup to schedule
  # a ActiveJob (Rails 4.2+).
  mattr_accessor :on_publish_with_notifications
  @@on_publish_with_notifications = nil

  # Search adapter to use for searching through Storytime Posts or
  # Post subclasses. Options for the search adapter include:
  # Storytime::PostgresSearchAdapter, Storytime::MysqlSearchAdapter,
  # Storytime::MysqlFulltextSearchAdapter, Storytime::Sqlite3SearchAdapter
  mattr_accessor :search_adapter
  @@search_adapter = nil

  # AWS Region to use for file uploads.
  mattr_accessor :aws_region
  @@aws_region = ENV['STORYTIME_AWS_REGION']

  # AWS Access Key ID to use for file uploads.
  mattr_accessor :aws_access_key_id
  @@aws_access_key_id = ENV['STORYTIME_AWS_ACCESS_KEY_ID']

  # AWS Secret Key to use for file uploads.
  mattr_accessor :aws_secret_key
  @@aws_secret_key = ENV['STORYTIME_AWS_SECRET_KEY']

  # Superclass for Storytime::ApplicationController
  # Defaults to the host app's ApplicationController
  mattr_accessor :application_controller_superclass
  @@application_controller_superclass = "::ApplicationController"

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
      @@user_class.underscore
    end

    def user_class_underscore_all
      @@user_class.underscore.gsub('/', '_')
    end

    def user_class_symbol
      @@user_class.underscore.to_sym
    end

    def application_controller_superclass
      @@application_controller_superclass.constantize
    end
  end
end