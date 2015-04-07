Storytime.configure do |config|
  # Name of the model you're using for Storytime users.
  <%= @enable_user_class ? nil : '# ' %>config.user_class = '<%= @user_class %>'

  # Path of Storytime's dashboard, relative to
  # Storytime's mount point within the host app.
  <%= @enable_dashboard_namespace_path ? nil : '# ' %>config.dashboard_namespace_path = '<%= @dashboard_namespace_path %>'

  # Path used to sign users in. 
  # config.login_path = '/users/sign_in'

  # Method used for Storytime user logout path.
  # config.logout_method = :delete

  # Add custom post types to use within Storytime.
  # Make sure that the custom post types inherit the
  # from the Storytime::Post class.
  <%= @enable_post_types ? nil : '# ' %>config.post_types += <%= @post_types %>

  # Character limit for Storytime::Post.title <= 255
  <%= @enable_post_title_character_limit ? nil : '# ' %>config.post_title_character_limit = <%= @post_title_character_limit %>

  # Character limit for Storytime::Post.excerpt
  <%= @enable_post_excerpt_character_limit ? nil : '# ' %>config.post_excerpt_character_limit = <%= @post_excerpt_character_limit %>

  # Hook for handling post content sanitization.
  # Accepts either a Lambda or Proc which can be used to
  # handle how post content is sanitized (i.e. which tags,
  # HTML attributes to allow/disallow.
  # config.post_sanitizer = Proc.new do |draft_content|
  #   white_list_sanitizer = if Rails::VERSION::MINOR <= 1
  #     HTML::WhiteListSanitizer.new
  #   else
  #     Rails::Html::WhiteListSanitizer.new
  #   end
  #
  #   attributes = %w(
  #     id class href style src title width height alt value 
  #     target rel align disabled
  #   )
  #
  #   if Storytime.whitelisted_post_html_tags.blank?
  #     white_list_sanitizer.sanitize(draft_content, attributes: attributes)
  #   else
  #     white_list_sanitizer.sanitize(draft_content,
  #                                   tags: Storytime.whitelisted_post_html_tags,
  #                                   attributes: attributes)
  #   end
  # end

  # Enable Disqus comments using your forum's shortname,
  # the unique identifier for your website as registered on Disqus.
  <%= @enable_disqus_forum_shortname ? nil : '# ' %>config.disqus_forum_shortname = '<%= @disqus_forum_shortname %>'

  # Enable Discourse comments using your discourse server,
  # Your discourse server must be configured for embedded comments.
  # e.g. config.discourse_name = "http://forum.example.com"
  # NOTE:  include the '/' suffix at the end of the url
  <%= @enable_discourse_name ? nil : '# ' %>config.discourse_name = '<%= @discourse_name %>'

  # Email regex used to validate email format validity for subscriptions.
  <%= @enable_email_regexp ? nil : '# ' %>config.email_regexp = <%= @email_regexp %>

  # Search adapter to use for searching through Storytime Posts or
  # Post subclasses. Options for the search adapter include:
  # Storytime::PostgresSearchAdapter, Storytime::MysqlSearchAdapter,
  # Storytime::MysqlFulltextSearchAdapter, Storytime::Sqlite3SearchAdapter
  <%= @enable_search_adapter ? nil : '# ' %>config.search_adapter = <%= @search_adapter %>

  # Hook for handling notification delivery when publishing content.
  # Accepts either a Lambda or Proc which can be set up to schedule
  # an ActiveJob (Rails 4.2+), for example:
  # 
  # config.on_publish_with_notifications = Proc.new do |post|
  #   wait_until = post.published_at + 1.minute
  #   StorytimePostNotificationJob.set(wait_until: wait_until).perform_later(post.id)
  # end
  # 
  ### In app/jobs/storytime_post_notification_job.rb:
  # class StorytimePostNotificationJob < ActiveJob::Base
  #   queue_as :mailers
  # 
  #   def perform(post_id)
  #     Storytime::PostNotifier.send_notifications_for(post_id)
  #   end
  # end
  config.on_publish_with_notifications = nil

  # File upload options.
  config.enable_file_upload = <%= @enable_file_upload %>

  # AWS Region to use for file uploads.
  # config.aws_region = <%= @aws_region %>

  # AWS Access Key ID to use for file uploads.
  # config.aws_access_key_id = <%= @aws_access_key_id %>

  # AWS Secret Key to use for file uploads.
  # config.aws_secret_key = <%= @aws_secret_key %>

  if Rails.env.production?
    config.media_storage = <%= @prod_media_storage %>
    <%= @enable_file_upload && @prod_media_storage == ':s3' ? nil : '# ' %>config.s3_bucket = '<%= @s3_bucket %>'
  else
    config.media_storage = <%= @dev_media_storage %>
  end
end
